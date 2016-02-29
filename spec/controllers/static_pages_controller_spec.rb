require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  context 'home' do
    before do
      get :home
    end
    it 'should get home' do
      expect(response).to have_http_status :success
    end
  end

  context 'help' do
    before do
      get :help
    end
    it 'should get help' do
      expect(response).to have_http_status :success
    end
  end

  context 'about' do
    before do
      get :about
    end
    it 'should get about' do
      expect(response).to have_http_status :success
    end
  end

  context 'contact' do
    before do
      get :contact
    end
    it 'should get contact' do
      expect(response).to have_http_status :success
    end
  end
end
