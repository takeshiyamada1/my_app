require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  context 'index when not logged in' do
    before do
      get :index
    end
    it 'should redirect index when not logged in' do
      expect(response).to redirect_to login_url
    end
  end

  context 'get new' do
    before do
      get :new
    end
    it 'should get new' do
      expect(response).to have_http_status :success
    end
  end

  context 'edit and update when not logged in' do
    let(:user) { create :tsubasa }
    context 'get edit id of user' do
      before do
        get :edit, id: user
      end
      it 'should redirect edit when not logged in' do
        expect(flash).to_not be_empty
        expect(response).to redirect_to login_url
      end
    end

    context 'patch update id of user' do
      before do
        patch :update, id: user, user: { name: user.name, email: user.email }
      end
      it 'should redirect update when not logged in' do
        expect(flash).to_not be_empty
        expect(response).to redirect_to login_url
      end
    end
  end

  context 'edit and update when logged in' do
    let(:user) { create :user }
    let(:other_user) { create :sayami }
    before do
      log_in_as(other_user)
    end
    context 'edit edit id of user' do
      before do
        get :edit, id: user
      end
      it 'should redirect edit when logged in as wrong user' do
        expect(flash).to be_empty
        expect(response).to redirect_to root_url
      end
    end

    context 'patch update id of user' do
      before do
        patch :update, id: user, user: { name: user.name, email: user.email }
      end
      it 'should redirect update when logged in as wrong user' do
        expect(flash).to be_empty
        expect(response).to redirect_to root_url
      end
    end
  end

  context 'redirect destroy' do
    let(:other_user) { create :sayami }
    let(:user) { create :tsubasa }
    before do
      user
    end
    it 'should redirect destroy when not logged in' do
      expect { delete :destroy, id: user }.to_not change { User.count }
      expect(response).to redirect_to login_url
    end
    context 'destroy when logged in' do
      before do
        log_in_as(other_user)
      end
      it 'should redirect destroy when logged in as a non-adin' do
        expect { delete :destroy, id: user }.to_not change { User.count }
        expect(response).to redirect_to root_url
      end
    end
  end

  context 'following and followers' do
    let(:user) { create :tsubasa }
    context 'get following id of user' do
      before do
        get :following, id: user
      end
      it 'should reidrect following when not logged in' do
        expect(response).to redirect_to login_url
      end
    end

    context 'get followers id of user' do
      before do
        get :followers, id: user
      end
      it 'should redirect followers when not logged in' do
        expect(response).to redirect_to login_url
      end
    end
  end
end