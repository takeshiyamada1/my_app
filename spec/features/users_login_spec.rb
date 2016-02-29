require 'rails_helper'

RSpec.feature 'UsersLogin', type: :feature do
  context 'users login' do
    let(:user) { create :tsubasa }

    context 'invalid information' do
      before do
        visit login_path
      end
      it 'login with invalid information' do
        expect(page).to have_selector 'h1', text: 'Log in'
        fill_in 'Email', with: ' '
        fill_in 'Password', with: ' '
        click_button 'Log in'
        expect(page).to have_selector 'h1', text: 'Log in'
        expect(page).to have_selector '.alert'
        visit root_path
        expect(page).to have_no_selector '.alert'
      end
    end

    context 'valid information' do
      before do
        visit login_path
      end
      it 'login with valid information' do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button 'Log in'
        expect(logged_on?(user)).to be_truthy
        expect(current_path).to eq user_path(user)
        expect(page).to have_selector 'h1', text: user.name
        expect(page).to have_link nil, href: login_path, count: 0
        expect(page).to have_link nil, href: logout_path
        expect(page).to have_link nil, href: user_path(user)
      end
    end

    context 'followe by logout' do
      before do
        visit login_path
      end
      it 'login with valid information followe by logout' do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button 'Log in'
        expect(logged_on?(user)).to be_truthy
        expect(current_path).to eq user_path(user)
        expect(page).to have_selector 'h1', text: user.name
        expect(page).to have_link nil, href: login_path, count: 0
        expect(page).to have_link nil, href: logout_path
        expect(page).to have_link nil, href: user_path(user)
        click_link 'Log out'
        expect(logged_on?(user)).to be_falsey
        expect(current_path).to eq root_path
        expect(page).to have_link nil, href: login_path
        expect(page).to have_no_link nil, href: logout_path
        expect(page).to have_no_link nil, href: user_path(user)
      end
    end

    context 'with remembering' do
      before do
        sign_in_as(user, remember_me: '1')
      end
      it 'login with remembering' do
        expect(page.driver.cookies['remember_token']).to be_present
      end
    end

    context do
      before do
        sign_in_as(user, remember_me: '0')
      end
      it 'login without remembering' do
        expect(page.driver.cookies['remember_token']).to be_blank
      end
    end
  end
end
