require 'rails_helper'

RSpec.feature "UsersProfile",type: :feature do
  include ApplicationHelper

  before do
    @user = create :tsubasa
  end

  it "profile display" do
    pending("Couldn't find User")
    visit user_path(@user)
    expect(page).to have_selector 'h1', text: @user.name
    expect(page).to have_title full_title(@user.name)
    expect(page).to have_selector 'h1', text: @user.name
    expect(page).to have_selector 'h1>img.gravatar'
    expect(page).to have_content @user.microposts.count
    @user.microposts.paginate(page: 1).each do |micropost|
      expect(page).to have_content micropost.content
    end
  end
end