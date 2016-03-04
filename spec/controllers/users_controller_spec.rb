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

  context 'get new' do
    before do
      get :new
    end
    it 'should get new' do
      expect(response).to have_http_status :success
    end
  end

  context 'create user' do
    context 'create valid user' do
      before do
        ActionMailer::Base.deliveries.clear
        post :create, user: { name: 'User Example', email: 'user@example.com', password: 'password', password_confirmation: 'password' }
      end
      it 'cleat new user' do
        expect(response).to redirect_to root_url
        expect(flash).to be_present
        expect(ActionMailer::Base.deliveries.size).to eq(1)
      end
    end
    context 'create invalid user' do
      shared_examples_for 'invalid user' do
        before do
          post :create, user: { name: 'User Example', email: email, password: password, password_confirmation: confirmation }
        end
        it 'create not new user' do
          expect(response).to render_template(:new)
        end
      end
      context 'invalid email' do
        it_behaves_like 'invalid user' do
          let(:email) { 'user@example' }
          let(:password) { 'password' }
          let(:confirmation) { 'password' }
        end
      end
      context 'invalid password' do
        it_behaves_like 'invalid user' do
          let(:email) { 'user@example.com' }
          let(:password) { 'pass' }
          let(:confirmation) { 'word' }
        end
      end
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