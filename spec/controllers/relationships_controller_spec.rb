require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  
  it "create should require logged-in user" do
    expect { post :create }.to_not change{ Relationship.count }
    expect(response).to redirect_to login_url
  end

  it "destroy should require logged-in" do
    one = create :one
    expect { delete :destroy, id: one }.to_not change{ Relationship.count }
    expect(response).to redirect_to login_url
  end
end