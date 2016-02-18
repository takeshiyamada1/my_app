require 'rails_helper'

RSpec.describe User,type: :models do
  
  let(:user) { User.new(name: "Example User", email: "user@example.com", password: "password", password_confirmation: "password") }

  it "should be valid" do
    pending("Failure/Error")
    expect(user).to be_valid
  end

  it "name should be presentds" do
    user.name = ' '
    expect(user).to_not be_valid
  end

  it "email should be present" do
    user.email = ' '
    expect(user).to_not be_valid
  end

  it "name should not be too long" do
    user.name = 'a'*51
    expect(user).to_not be_valid
  end

  it "email should not be too long" do
    user.email = 'a'*244 + "@example.com"
    expect(user).to_not be_valid
  end

  it "email validation should accept valid addresses" do
    pending("Failure/Error")
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      expect(user).to be_valid, "#{valid_address.inspect} should be valid"
    end
  end

  it "email addresses should be unique" do
    duplicate_user = user.dup
    duplicate_user.email = user.email.upcase
    user.save
    expect(duplicate_user).to_not be_valid
  end

  it "password should be present (nonblank)" do
    user.password = user.password_confirmation = "" * 6
    expect(user).to_not be_valid
  end

  it "authenticated? should return false for a user with nil digest" do
    expect(user).to_not be_authenticated(:remember, '')
  end

  it "associated microposts should be destroyed" do
    pending("Failure/Error")
    user.save
    user.microposts.create!(content: "Lorem ipsum")
    expect { user.destroy }.to change{ Micropost.count }.by(-1)
  end

  it "should follow and unfollow a user" do
    tsubasa = create :tsubasa
    lana  = create :lana
    expect(tsubasa).to_not be_following(lana)
    tsubasa.follow(lana)
    expect(tsubasa).to be_following(lana)
    expect(lana.followers.include?(tsubasa)).to be_truthy
    tsubasa.unfollow(lana)
    expect(tsubasa).to_not be_following(lana)
  end

  it "feed should have the right posts" do
    tsubasa = create :tsubasa
    sayami = create :sayami
    lana = create :lana
    sayami.microposts.each do |post_following|
      expect(tsubasa.feed.include?(post_following)).to be_truthy
    end

    tsubasa.microposts.each do |post_self|
      expect(tsubasa.feed.include?(post_self)).to be_truthy
    end

    #フォローしていないユーザーの投稿を確認
    lana.microposts.each do |post_unfollowed|
      expect(tsubasa.feed.include?(post_unfollowed)).to_not be_truthy
    end
  end
end