require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  context 'get new' do
    before do
      get :new
    end
    it 'should get new' do
      expect(response).to have_http_status :success
    end
  end
end
