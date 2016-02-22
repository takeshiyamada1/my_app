require 'rails_helper'

RSpec.feature "MicropostsInterface", type: :feature do
  before do
    @user = create :tsubasa_with_microposts
  end

  it "micropost interface" do
    sign_in_as(@user)
    visit root_path
    expect(page).to have_selector 'div.pagination'

    #無効な送信
    fill_in 'micropost_content', with: ' '
    expect { click_button 'Post' }.to_not change{ Micropost.count }
    expect(page).to have_selector 'div#error_explanation'

    #有効な送信
    content = "This micropost really ties the room together"
    fill_in 'micropost_content', with: content
    expect { click_button 'Post' }.to change{ Micropost.count}.by(1)
    expect(current_path).to eq root_path
    expect(page).to have_content content

    #投稿を削除する
    expect(page).to have_link 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    expect { click_link 'delete', href: micropost_path(first_micropost) }.to change{ Micropost.count }.by(-1)

    #違うユーザーのプロフィールにアクセスする
    visit user_path(create :lana_with_microposts)
    expect(page).to have_no_link 'delete'
  end
end
