require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  context 'create and destroy logged-in' do
    it 'create should require logged-in user' do
      expect { post :create }.to_not change { Relationship.count }
      expect(response).to redirect_to login_url
    end

    context 'destroy logged-in' do
      let(:one) { create :one }
      before do
        one
      end
      it 'destroy should require logged-in' do
        expect { delete :destroy, id: one }.to_not change { Relationship.count }
        expect(response).to redirect_to login_url
      end
    end
  end

  context 'follow and unfollow with ajax' do
    let(:user) { create :tsubasa }
    let(:other) { create :sayami }
    before do
      log_in_as(user)
    end
    it 'should follow a user with ajax' do
      expect { xhr :post, :create, followed_id: other.id }.to change { user.following.count }.by(1)
    end

    context 'unfollow with ajax' do
      let(:relationship) { user.active_relationships.find_by(followed_id: other.id) }
      before do
        user.follow(other)
      end
      it 'should unfollow a user with ajax' do
        expect { xhr :post, :destroy, id: relationship.id }.to change { user.following.count }.by(-1)
      end
    end
  end
end