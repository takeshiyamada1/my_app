require 'rails_helper'

RSpec.feature 'UsersLogin', type: :feature do
  before do
    @user = create :tsubasa
  end

  it 'login with invalid information' do
    visit login_path
    expect(page).to have_selector 'h1', text: 'Log in'
    fill_in 'Email', with: ' '
    fill_in 'Password', with: ' '
    click_button 'Log in'
    expect(page).to have_selector 'h1', text: 'Log in'
    expect(page).to have_selector '.alert'
    visit root_path
    expect(page).to have_no_selector '.alert'
  end

  it 'login with valid information' do
    visit login_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Log in'
    expect(logged_on?(@user)).to be_truthy
    expect(current_path).to eq user_path(@user)
    expect(page).to have_selector 'h1', text: @user.name
    expect(page).to have_link nil, href: login_path, count: 0
    expect(page).to have_link nil, href: logout_path
    expect(page).to have_link nil, href: user_path(@user)
  end

  it 'login with valid information followe by logout' do
    visit login_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Log in'
    expect(logged_on?(@user)).to be_truthy
    expect(current_path).to eq user_path(@user)
    expect(page).to have_selector 'h1', text: @user.name
    expect(page).to have_link nil, href: login_path, count: 0
    expect(page).to have_link nil, href: logout_path
    expect(page).to have_link nil, href: user_path(@user)
    click_link 'Log out'
    expect(logged_on?(@user)).to be_falsey
    expect(current_path).to eq root_path
    expect(page).to have_link nil, href: login_path
    expect(page).to have_no_link nil, href: logout_path
    expect(page).to have_no_link nil, href: user_path(@user)
  end

  it 'login with remembering' do
    pending('no method cookies')
    sign_in_as(@user, remember_me: '1')
    expect(cookies['remember_token']).to_not be_nil
  end

  it 'login without remembering' do
    pending('no method cookies')
    sign_in_as(@user, remember_me: '0')
    expect(cookies['remember_token']).to be_nil
  end
end
