require 'rails_helper'

RSpec.describe Micropost, type: :models do
  let(:user) { create :tsubasa }
  let(:micropost) { user.microposts.build(content: 'Lorem ipsum') }

  it 'should be valid' do
    expect(micropost).to be_valid
  end

  it 'user id should be present' do
    micropost.user = nil
    expect(micropost).to_not be_valid
  end

  it 'content should be present' do
    micropost.content = ' '
    expect(micropost).to_not be_valid
  end

  it 'content should be at most 140 characters' do
    micropost.content = 'a' * 141
    expect(micropost).to_not be_valid
  end

  it 'order should be most recent first' do
    microposts = create :most_recent
    expect(microposts).to eq Micropost.first
  end
end
