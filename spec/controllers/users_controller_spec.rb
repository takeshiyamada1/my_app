require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create :tsubasa }
  let(:other_user) { create :sayami }
  shared_examples_for 'not logged in' do
    let(:user) { create :tsubasa }
    it 'should redirect when not logged in' do
      expect(flash).to_not be_empty
      expect(response).to redirect_to login_url
    end
  end
  context 'index when not logged in' do
    before do
      get :index
    end
    it_behaves_like 'not logged in'
  end

  context 'get　show' do
    before do
      get :show, id: user
    end
    it 'should get show' do
      expect(response).to have_http_status :success
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
    context 'get edit id of user' do
      before do
        get :edit, id: user
      end
      it_behaves_like 'not logged in'
    end

    context 'patch update id of user' do
      before do
        patch :update, id: user, user: { name: user.name, email: user.email }
      end
      it_behaves_like 'not logged in'
    end
  end

  context 'edit and update when logged in' do
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
    context 'destroy when not logged in' do
      before do
        delete :destroy, id: user
      end
      it_behaves_like 'not logged in'
    end

    context 'destroy when logged in' do
      before do
        log_in_as(other_user)
        delete :destroy, id: user
      end
      it 'should redirect destroy' do
        expect { delete :destroy, id: user }.to_not change { User.count }
        expect(response).to redirect_to root_url
      end
    end
  end

  context 'following and followers' do
    context 'get following id of user' do
      before do
        get :following, id: user
      end
      it_behaves_like 'not logged in'
    end

    context 'get followers id of user' do
      before do
        get :followers, id: user
      end
      it_behaves_like 'not logged in'
    end
  end
end