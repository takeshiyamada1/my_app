require 'rails_helper'

RSpec.feature "PasswordRests",type: :feature do
  before do
    ActionMailer::Base.deliveries.clear
    @user = create :tsubasa
  end

  it "password resets" do
    pending("no method")
    visit new_password_reset_path
    expect(page).to have_selector 'h1', text: "Forgot password"

    #メールアドレスが無効
    fill_in "Email", with: ' '
    click_button 'Submit'
    expect(page).to have_selector '.alert'
    expect(page).to have_selector 'h1', text: "Forgot password"

    #メールアドレス有効
    fill_in "Email", with: @user.email
    click_button 'Submit'
    expect(ActionMailer::Base.deliveries.size).to eq 1
    expect(@user.reload.reset_digest).to eq @user.reset_digest
    expect(page).to have_selector '.alert'
    expect(current_url).to eq root_url
    #パスワード再設定用フォーム
    user = assigns(:user)
    
    #メールアドレスが無効
    visit edit_password_reset_path(user.reset_token, email: '')
    expect(current_url).to eq root_url

    #無効なユーザー
    user.toggle!(:activeated)
    visit edit_password_reset_path(user.reset_token,email: user.email)
    expect(current_url).to eq root_url
    user.toggle!(:activeated)

    #メールアドレスが正しく、トークンが無効
    visit edit_password_reset_path(user.reset_token, email: user.email)
    expect(page).to have_selector 'h1', 'Reset password'
    expect(page).to have_selector 'input[name=email][type=hidden]', user.email

    #無効なパスワードと確認
    fill_in "Password", with: "foobaz"
    fill_in "Confirmaiton", with: "barquux"
    click_button "Update password"
    expect(page).to have_selector 'div#error_explanation'

    #パスワードがから
    fill_in "Password", with: ' '
    fill_in "Confirmation", with: ' '
    click_button "Update password"
    expect(page).to have_selector 'div#error_explanation'

    #有効なパスワードと確認
    fill_in "Password", with: "foobaz"
    fill_in "Confirmation", with: "foobaz"
    click_button "Update password"
    expect(is_logged_in?).to be_truthy
    expect(page).to have_selector '.alert'
    expect(current_paht).to eq user_path(@user)
  end
end