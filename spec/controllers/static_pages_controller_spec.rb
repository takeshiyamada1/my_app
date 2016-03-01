require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  shared_examples_for 'should get page' do
    before do
      get page
    end
    it 'should get page' do
      expect(response).to have_http_status :success
    end
  end
  context 'home' do
    it_behaves_like 'should get page' do
      let(:page) { :home }
    end
  end

  context 'help' do
    it_behaves_like 'should get page' do
      let(:page) { :help }
    end
  end

  context 'about' do
    it_behaves_like 'should get page' do
      let(:page) { :about }
    end
  end

  context 'contact' do
    it_behaves_like 'should get page' do
      let(:page) { :contact }
    end
  end
end
