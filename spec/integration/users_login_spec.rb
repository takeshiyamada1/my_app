require 'rails_helper'

RSpec.describe "Pending Examples UsersLogin" do
  def setup
    @user = create :tsubasa
  end

  it "login with invalid information" do
    pending("change features")
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: "", password: "" }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  it "login with valid information" do
    pending("change features")
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

  it "login with valid information followed by logout" do
    pending("change features")
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  it "login with remembering" do
    pending("change features")
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end

  it "login without remebering" do
    pending("change features")
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end
end