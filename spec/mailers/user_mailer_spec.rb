require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  context 'account' do
    let(:user) { create :tsubasa }
    let(:mail) { UserMailer.account_activation(user) }
    before do
      user.activation_token = User.new_token
    end
    it 'account_activation' do
      expect(mail).to have_attributes subject: 'Account activation', to: [user.email], from: ['from@example.com']
      expect(mail.body.encoded).to match user.name
      expect(mail.body.encoded).to match user.activation_token
      expect(mail.body.encoded).to match CGI.escape(user.email)
    end
  end

  context 'password' do
    let(:user) { create :tsubasa }
    let(:mail) { UserMailer.password_reset(user) }
    before do
      user.reset_token = User.new_token
    end
    it 'password_reset' do
      expect(mail).to have_attributes subject: 'Password reset', to: [user.email], from: ['from@example.com']
      expect(mail.body.encoded).to match user.reset_token
      expect(mail.body.encoded).to match CGI.escape(user.email)
    end
  end
end
