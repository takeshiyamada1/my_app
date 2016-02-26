require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do

  context 'create and destroy when not logged in' do
    let!(:micropost) { create :orange }

    it 'should redirect create when not logged in' do
      expect { post :create, micropost: { content: 'Lorem ipsum' } }.to_not change { Micropost.count }
      expect(response).to redirect_to login_url
    end

    it 'should redirect destroy when not logged in' do
      expect { delete :destroy, id: micropost }.to_not change { Micropost.count }
      expect(response).to redirect_to login_url
    end
  end

  context 'wrong micropost destroy' do
    let(:user) { build :tsubasa }
    let!(:ants) { create :ants }
    let!(:micropost) { create :orange }
    before do
      log_in_as(user)
    end

    it 'should redirect destroy for wrong micropost' do
      expect { delete :destroy, id: ants }.to_not change { Micropost.count }
      expect(response).to redirect_to root_url
    end
  end
end