require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { create :tsubasa }
  context 'get new' do
    before do
      get :new
    end
    it 'should get new' do
      expect(response).to have_http_status :success
    end
  end

  context 'get create' do

    context 'invalid information' do
      before do
        get :create, session: { email: user.email }
      end
      it 'create should when not user login' do
        expect(response).to render_template(:new)
        expect(logged_in?).to be_falsey
        expect(flash).to_not be_empty
      end
    end

    context 'get create valid information' do
      before do
        get :create, session: { email: user.email, password:user.password, remember_me: '1'}
      end
      context 'invalid account activations' do
        let(:user){ create :tsubasa, activated: false, activated_at: nil }
        it 'create should when not user login invalid account activations' do
          expect(response).to redirect_to root_url
          expect(flash).to_not be_empty
          expect(logged_in?).to be_falsey
        end
      end

      it 'create should when user login' do
        expect(response).to redirect_to user_path(user)
        expect(logged_in?).to be_truthy
        expect(cookies['remember_token']).to be_present
      end
    end
  end
end
