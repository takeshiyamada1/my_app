require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { create :tsubasa }
  context 'get new' do
    before do
      post :new
    end
    it 'should post new' do
      expect(response).to have_http_status :success
    end
  end

  context 'post create' do
    context 'invalid information' do
      before do
        post :create, session: { email: user.email }
      end
      it 'create should when not user login' do
        expect(response).to render_template(:new)
        expect(logged_in?).to be_falsey
        expect(flash).to_not be_empty
      end
    end

    context 'post create valid information' do
      before do
        post :create, session: { email: user.email, password:user.password, remember_me: '1'}
      end
      context 'invalid account activations' do
        let(:user){ create :tsubasa, activated: false, activated_at: nil }
        it 'create should when not user login invalid account activations' do
          expect(response).to redirect_to root_url
          expect(flash).to_not be_empty
          expect(logged_in?).to be_falsey
        end
      end
      context 'remember_token on' do
        it 'create should when user login rememeber_me on' do
          expect(response).to redirect_to user_path(user)
          expect(logged_in?).to be_truthy
          expect(cookies['remember_token']).to be_present
        end
      end
    end
    context 'remember_token off' do
      before do
        post :create, session: { email: user.email, password:user.password, remember_me: '0'}
      end
      it 'create should when user login remember_me off' do
        expect(response).to redirect_to user_path(user)
        expect(logged_in?).to be_truthy
        expect(cookies['remember_token']).to be_blank
      end
    end
  end
end
