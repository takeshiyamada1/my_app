require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  shared_examples_for 'logged in' do
    let(:user) { create :tsubasa }
    it 'should redirect when not logged in' do
      expect(flash).to method
      expect(response).to redirect_to url
    end
  end
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
    context 'get edit id of user' do
      before do
        get :edit, id: user
      end
      it_behaves_like 'logged in' do
        let(:url) { login_url }
        let(:method) { be_present }
      end
    end

    context 'patch update id of user' do
      before do
        patch :update, id: user, user: { name: user.name, email: user.email }
      end
      it_behaves_like 'logged in' do
        let(:url) { login_url }
        let(:method) { be_present }
      end
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
      it_behaves_like 'logged in' do
        let(:url) { root_url }
        let(:method) { be_empty }
      end
    end

    context 'patch update id of user' do
      before do
        patch :update, id: user, user: { name: user.name, email: user.email }
      end
      it_behaves_like 'logged in' do
        let(:url) { root_url }
        let(:method) { be_empty }
      end
    end
  end

  context 'redirect destroy' do
    let(:other_user) { create :sayami }
    let(:user) { create :tsubasa }
    before do
      user
    end
    context 'destroy when not logged in' do
      it 'should redirect destroy' do
        expect { delete :destroy, id: user }.to_not change { User.count }
        expect(response).to redirect_to login_url
      end
    end

    context 'destroy when logged in' do
      before do
        log_in_as(other_user)
      end
      it 'should redirect destroy' do
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
      it 'should redirec when not logged in' do
        expect(response).to redirect_to login_url
      end
    end

    context 'get followers id of user' do
      before do
        get :followers, id: user
      end
      it 'should redirec when not logged in' do
        expect(response).to redirect_to login_url
      end
    end
  end
end