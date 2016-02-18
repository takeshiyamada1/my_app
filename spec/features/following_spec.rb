require 'rails_helper'

RSpec.feature "Following", type: :feature do
  before do
    @user = create :tsubasa
    @other= create :lana
    sign_in_as(@user)
  end

  it "following page" do
    visit following_user_path(@user)
    expect(@user.following.empty?).to be false
    expect(page).to have_content @user.following.count
    @user.following.each do |user|
      expect(page).to have_link nil, href: user_path(user)
    end
  end

  it "followers page" do
    visit followers_user_path(@user)
    expect(@user.followers.empty?).to be false
    expect(page).to have_content @user.followers.count
    @user.followers.each do |user|
      expect(page).to have_link nil, href: user_path(user)
    end
  end

  it "should follow a user the standard way" do
    visit user_path(@other)
    expect { click_button 'Follow' }.to change{ @user.following.count }.by(1)
  end

  it "should follow a user with Ajax" do 
    pending('error')
    expect { xhr :post, :create, followed_id: @other.id }.to change{ @user.following.count}.by(1)
  end

  it "should unfollow a user the standard way" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    visit user_path(@other)
    expect { click_button 'Unfollow' }.to change{ @user.following.count }.by(-1)
  end


  it "should unfollow a user with Ajax" do
    pending('error')
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    expect{ xhr :delete, :destroy, id: relationship_id }.to change{ @user.following.count}.by(-1)
  end
end