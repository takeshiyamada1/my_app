#テストユーザーがログインしていればtrueを返す
def is_logged_in?
  !session[:user_id].nil?
end
#feature spec 用テストユーザーがログインしていればtrueを返す
def logged_in?(user)
  if current_path == user_path(user)
    click_link 'Account'
  end
  page.has_link? 'Log out'
end

#controller spec用テストユーザーとしてログインする
def log_in_as(user, options = {})
  password = options[:password] ||'password'
  remember_me = options[:remember_me] || '1'
  session[:user_id] = user.id
end
#feature spec用テストユーザーとしてログイン
def sign_in_as(user, options = {})
  password = options[:password] ||'password'
  remember_me = options[:remember_me] || '1'
  visit login_path
  fill_in 'Email', with: user.email
  fill_in 'Password', with: password
  click_button 'Log in'
end
private

  #統合テスト内ではtrueを返す
  def integration_test?
    defined?(post_via_redirect)
  end