require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  
  it "should ge new" do
    get :new
    expect(response).to have_http_status :success
  end
end