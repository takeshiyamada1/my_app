require 'rails_helper'

RSpec.feature "UsersIndex",type: :feature do
  before do
    @admin = create :tsubasa
    @non_admin = create :sayami
  end

  it "index as admin including pagination and delete links" do |variable|
    pending('no patch pagination')
    sign_in_as(@admin)
    visit users_path
    expect(page).to have_selector 'h1', text: 'All users'
    expect(page).to have_selector 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      expect(page).to have_link user.name, href: user_path(user)
      unless user == @admin
        expect(page).to have_link 'delete', href: user_path
      end
    end
    expect { click_link 'delete',href: user_path(@non_admi) }.to change{ User.count }.by(-1)
  end

  it "index as non-admin" do
    sign_in_as(@non_admin)
    visit users_path
    expect(page).to have_no_link 'delete'
  end
end