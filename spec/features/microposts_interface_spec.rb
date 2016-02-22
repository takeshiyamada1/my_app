require 'rails_helper'

RSpec.feature "MicropostsInterface", type: :feature do
  before do
    @user = create :tsubasa_with_microposts
  end

  it "micropost interface" do
    pending('error')
    sign_in_as(@user)
    expect(page).to have_selector 'div.pagination'

    #無効な送信
    expect { click_button 'post' }.to_not change{ Micropost.count }
    expect(page).to have_selector 'dive#error_explanation'

    #有効な送信
    content = "This micropost really ties the room together"
    expect { click_button 'post' }.to change{ Micropost.count}.by(1)
    expect(current_url).to eq root_url
    follow_redirect!
    expect(page).to have_content content

    #投稿を削除する
    expect(page).to have_link 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first_micropost
    expect { click_button  'delete', href: micropost_path(first_micropost) }.to change{ Micropost.count }.by(-1)
    #違うユーザーのプロフィールにアクセスする
    visit user_path(create :lana)
    expect(page).to have_link 'delete'
  end
end
