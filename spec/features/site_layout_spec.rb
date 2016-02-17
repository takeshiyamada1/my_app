require 'rails_helper'

RSpec.feature "SiteLayout",type: :feature do
  it "layout links" do
    visit root_path
    expect(page).to have_title "Ruby on Rails Tutorial Sample App"
    expect(page).to have_link nil, href: root_path, count: 2
    expect(page).to have_link nil, href: help_path
    expect(page).to have_link nil, href: about_path
    expect(page).to have_link nil, href: contact_path
  end
end