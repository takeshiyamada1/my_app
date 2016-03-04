require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  let(:user) { create :tsubasa }
  context 'get create password reset' do
    before do
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
end
