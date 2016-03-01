require 'rails_helper'

RSpec.feature 'Following', type: :feature do
  context 'following spec' do
    let(:user) { create :tsubasa }
    let(:other) { create :sayami }
    before do
      sign_in_as(user)
      create :one
      create :two
      create :three
      create :four
    end

    context 'following' do
      before do
        visit following_user_path(user)
      end
      it 'following page' do
        expect(user.following.empty?).to be_falsey
        expect(page).to have_content user.following.count
        user.following.each do |user|
          expect(page).to have_link nil, href: user_path(user)
        end
      end
    end

    context 'followers' do
      before do
        visit followers_user_path(user)
      end
      it 'followers page' do
        expect(user.followers.empty?).to be_falsey
        expect(page).to have_content user.followers.count
        user.followers.each do |user|
          expect(page).to have_link nil, href: user_path(user)
        end
      end
    end

    context 'follow user' do
      let(:before_count) { user.following.count }
      before do
        before_count
        visit user_path(other)
      end
      it 'should follow a user the standard way' do
        click_button 'Follow'
        expect(page).to have_button 'Unfollow'
        expect(user.following.count).to eq(before_count + 1)
      end
    end

    context 'unnfolow user' do
      let(:before_count) { user.following.count }
      before do
        user.follow(other)
        before_count
        visit user_path(other)
      end
      it 'should unfollow a user the standard way' do
        click_button 'Unfollow'
        expect(page).to have_button 'Follow'
        expect(user.following.count).to eq(before_count - 1)
      end
    end
  end
end
