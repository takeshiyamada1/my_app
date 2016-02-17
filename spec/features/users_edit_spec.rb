require 'rails_helper'

RSpec.feature "UsersEdit",type: :feature do
  before do
    @user = create :tsubasa
  end

  it "unsuccessful edit" do
    sign_in_as(@user)
    visit edit_user_path(@user)
    expect(page).to have_selector 'h1', text: 'Update your profile'
    fill_in 'Name', with: ""
    fill_in 'Email', with: "user@invalid"
    fill_in 'Password', with: "foo"
    fill_in 'Confirmation', with: "bar"
    click_button 'Save changes'
    expect(page).to have_selector 'h1', text: 'Update your profile'
  end

  it "successful edit with friendly forwarding" do
    pending('expected: "Foo Bar" line35')
    visit edit_user_path(@user)
    sign_in_as(@user)
    expect(current_path).to eq edit_user_path(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    fill_in "Name", with: name
    fill_in "Email", with: email
    fill_in "Password", with: ' '
    fill_in "Confirmation", with: ' '
    click_button 'Save change'
    expect(page).to have_selector '.alert'
    expect(current_path).to eq user_path(@user)
    @user.reload
    expect(@user.name).to eq name
    expect(@user.email).to eq email
  end
end