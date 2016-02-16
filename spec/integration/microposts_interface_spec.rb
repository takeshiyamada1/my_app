require 'rails_helper'

RSpec.describe "Pending Examples MicropostsInterface" do
  def setup
    @user = create :tsubasa
  end

  it "micropost interface" do
    pending("change features")
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'

    # 無効な送信
    assert_no_difference 'Micropost.count' do
      post microposts_path, micropost: { content: "" }
    end
    assert_select 'div#error_explanation'
    # 有効な送信
    content = "This micropost really ties the room together"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: content }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # 投稿を削除する
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # 違うユーザーのプロフィールにアクセスする
    get user_path(create :lana)
    assert_select 'a', text: 'delete', count: 0
  end
end