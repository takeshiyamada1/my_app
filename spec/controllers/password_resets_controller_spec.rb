require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  let(:user) { create :tsubasa }
  context 'get new' do
    before do
      get :new
    end
    it 'get action' do
      expect(response).to have_http_status :success
    end
  end

  context 'get create password reset' do
    before do
      ActionMailer::Base.deliveries.clear
      post :create, password_reset: { email: user.email }
    end
    it 'create shoule when user password reset' do
      expect(response).to redirect_to root_url
      expect(flash).to be_present
      expect(user.reload.reset_digest).to be_present
      expect(ActionMailer::Base.deliveries.size).to eq 1
    end
  end
  context 'get create not password reset' do
    before do
      post :create, password_reset: { email: 'invalid' }
    end
    it 'create should when not user password reset' do
      expect(response).to render_template(:new)
      expect(flash).to be_present
    end
  end

  context 'get edit' do
    before do
      user.create_reset_digest
      get :edit, id: user.reset_token, email: user.email
    end
    it 'edit check status code' do
      expect(response).to have_http_status :success
    end
  end
end
