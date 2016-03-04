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

  context 'update user password' do
    before do
      user.create_reset_digest
      patch :update, id: user.reset_token, email: user.email, user: { password: 'foobaz', password_confirmation: 'foobaz' }
    end
    it 'update should when user password preset' do
      expect(response).to redirect_to user_url(user)
      expect(flash).to be_present
      expect(user.reload.authenticate('foobaz')).to be_truthy
      expect(logged_in?).to be_truthy
    end
  end

  shared_examples_for 'invalid reset' do
    before do
      user.create_reset_digest
      patch :update, id: user.reset_token, email: user.email, user: { password: password, password_confirmation: confirmation }
    end
    it 'update should not user password reset' do
      expect(response).to render_template(:edit)
      expect(user.errors).to be_truthy
    end
  end
  context 'update missed by without password' do
    it_behaves_like 'invalid reset' do
      let(:password) { '' }
      let(:confirmation) { '' }
    end
  end
  context 'update missed by invalid password' do
    it_behaves_like 'invalid reset' do
      let(:password) { 'foobaz' }
      let(:confirmation) { 'barfoo' }
    end
  end
end
