# テストユーザーがログインしていればtrueを返す
def logged_in?
  !session[:user_id].nil?
end

# feature spec 用テストユーザーがログインしていればtrueを返す
def logged_on?(user)
  click_link 'Account' if current_path == user_path(user)
  page.has_link? 'Log out'
end

# controller spec用テストユーザーとしてログインする
def log_in_as(user)
  session[:user_id] = user.id
end

# feature spec用テストユーザーとしてログイン
def sign_in_as(user, options = {})
  password = options[:password] || 'password'
  remember_me = options[:remember_me] || '1'
  visit login_path
  fill_in 'Email', with: user.email
  fill_in 'Password', with: password
  check 'Remember me on this computer' if remember_me == '1'
  click_button 'Log in'
end
