require 'rails_helper'

RSpec.feature 'UsersProfile', type: :feature do
  context 'user profile' do
    include ApplicationHelper
    let(:user) { create :tsubasa }
    before do
      visit user_path(user)
    end
    it 'profile display' do
      expect(page).to have_selector 'h1', text: user.name
      expect(page).to have_title full_title(user.name)
      expect(page).to have_selector 'h1', text: user.name
      expect(page).to have_selector 'h1>img.gravatar'
      expect(page).to have_content user.microposts.count
      user.microposts.paginate(page: 1).each do |micropost|
        expect(page).to have_content micropost.content
      end
    end
  end
end
