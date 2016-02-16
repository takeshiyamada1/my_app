require 'rails_helper'

RSpec.describe "Pending Examples Following", type: :integration do
  def setup
    @user = create :tsubasa
    @other = create :lana
    log_in_as(@user)
  end

  it "following page" do
    pending("change features")
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  it "followers page" do
    pending("change features")
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  it "should follow a user the standard way" do
    pending("change features")
    assert_difference '@user.following.count', 1 do
      post relationships_path, followed_id: @other.id
    end
  end

  it "should follow a user with Ajax" do
    pending("change features")
    assert_difference '@user.following.count', 1 do
      xhr :post, relationships_path, followed_id: @other.id
    end
  end

  it "should unfollow a user the standard way" do
    pending("change features")
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  it "should unfollow a user with Ajax" do
    pending("change features")
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      xhr :delete, relationship_path(relationship)
    end
  end
end