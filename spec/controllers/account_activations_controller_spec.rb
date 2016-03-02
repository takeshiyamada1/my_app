require 'rails_helper'

RSpec.describe AccountActivationsController, type: :controller do
  let(:user) { create :tsubasa, activated: false, activated_at: nil }
  context 'account active' do
    before do
      get :edit, id: user, email: user.email
    end
    it 'should edit when account active' do
      expect(response).to redirect_to user_path(user)
      expect(flash).to_not be_empty
      expect(user.activated?).to be_truthy
      expect(logged_in?).to be_truthy
    end
  end
end