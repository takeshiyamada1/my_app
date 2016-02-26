require 'rails_helper'

RSpec.feature 'Following', type: :feature do
  before do
    @user = create :tsubasa
    @other = create :sayami
    sign_in_as(@user)
    create :one
    create :two
    create :three
    create :four
  end

  it 'following page' do
    visit following_user_path(@user)
    expect(@user.following.empty?).to be_falsey
    expect(page).to have_content @user.following.count
    @user.following.each do |user|
      expect(page).to have_link nil, href: user_path(user)
    end
  end

  it 'followers page' do
    visit followers_user_path(@user)
    expect(@user.followers.empty?).to be_falsey
    expect(page).to have_content @user.followers.count
    @user.followers.each do |user|
      expect(page).to have_link nil, href: user_path(user)
    end
  end

  it 'should follow a user the standard way' do
    before_count = @user.following.count
    visit user_path(@other)
    click_button 'Follow'
    expect(page).to have_button 'Unfollow'
    expect(@user.following.count).to eq(before_count + 1)
  end

  it 'should unfollow a user the standard way' do
    @user.follow(@other)
    before_count = @user.following.count
    visit user_path(@other)
    click_button 'Unfollow'
    expect(page).to have_button 'Follow'
    expect(@user.following.count).to eq(before_count - 1)
  end
end
