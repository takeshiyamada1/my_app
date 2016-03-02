require 'rails_helper'

RSpec.describe AccountActivationsController, type: :controller do
  let(:user) { create :tsubasa }
  context 'account active' do
    before do
      get :edit, id: user, email: user.email
      log_in_as(user)
    end
    it 'should edit when account active' do
      expect(user.activated?).to be_truthy
      expect(flash).to_not be_empty
      expect(response).to redirect_to user_path(user)
    end
  end
end
