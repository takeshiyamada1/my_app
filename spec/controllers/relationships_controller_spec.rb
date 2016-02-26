require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  let(:user) { create :tsubasa }
  let(:other) { create :sayami }
  it 'create should require logged-in user' do
    expect { post :create }.to_not change { Relationship.count }
    expect(response).to redirect_to login_url
  end

  it 'destroy should require logged-in' do
    one = create :one
    expect { delete :destroy, id: one }.to_not change { Relationship.count }
    expect(response).to redirect_to login_url
  end

  it 'should follow a user with ajax' do
    log_in_as(user)
    expect { xhr :post, :create, followed_id: other.id }.to change { user.following.count }.by(1)
  end

  it 'should unfollow a user with ajax' do
    log_in_as(user)
    user.follow(other)
    relationship = user.active_relationships.find_by(followed_id: other.id)
    expect { xhr :post, :destroy, id: relationship.id }.to change { user.following.count }.by(-1)
  end
end
