require 'test_helper'

class UserTest < ActiveSupport::TestCase

  fixtures :users, :relationships

  def setup
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name= "     "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "eamil should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end


  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end	


  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = "" * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

   test "should follow and unfollow a user" do
    tsubasa = users(:tsubasa)
    lana  = users(:lana)
    assert_not tsubasa.following?(lana)
    tsubasa.follow(lana)
    assert tsubasa.following?(lana)
    assert lana.followers.include?(tsubasa)
    tsubasa.unfollow(lana)
    assert_not tsubasa.following?(lana)
  end

  test "feed should have the right posts" do
    tsubasa = users(:tsubasa)
    sayami = users(:sayami)
    lana = users(:lana)
    #フォローしているユーザーの投稿を確認
    sayami.microposts.each do |post_following|
      assert tsubasa.feed.include?(post_following)
    end

    #自分自身の投稿を確認
    tsubasa.microposts.each do |post_self|
      assert tsubasa.feed.include?(post_self)
    end

    #フォローしていないユーザーの投稿を確認
    lana.microposts.each do |post_unfollowed|
      assert_not tsubasa.feed.include?(post_unfollowed)
    end
  end
end

