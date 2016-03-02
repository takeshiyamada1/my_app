require 'rails_helper'

RSpec.describe AccountActivationsController, type: :controller do
  let(:user) { create :tsubasa, activated: false, activated_at: nil }
  shared_examples_for 'not account' do
    it 'shoule edit when not account' do
      expect(response).to redirect_to root_url
      expect(flash).to_not be_empty
      expect(logged_in?).to be_falsey
    end
  end
  context 'not account active' do
    context 'when not account active' do
      before do
        log_in_as(user)
      end
      it 'should edit when not account active' do
        expect(logged_in?).to be_falsey
      end
    end
    context 'invalid token' do
      before do
        get :edit, id: 'invalid token', email: user.email
      end
      it_behaves_like 'not account'
    end

    context 'wrong email' do
      before do
        get :edit, id: user.activation_token, email: 'wrong'
      end
      it_behaves_like 'not account'
    end
  end

  context 'account active' do
    before do
      get :edit, id: user.activation_token, email: user.email
    end
    it 'should edit when account active' do
      expect(response).to redirect_to user_path(user)
      expect(flash).to_not be_empty
      expect(user.reload.activated).to be_truthy
      expect(logged_in?).to be_truthy
    end
  end
end