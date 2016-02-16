require 'rails_helper'

RSpec.describe "Pending Examples UsersIndex" do

  def setup
    @admin     = create :tsubasa 
    @non_admin = create :sayami
  end

  it "index as admin including pagination and delete links" do
    pending("change features")
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  it "index as non-admin" do
    pending("change features")
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end