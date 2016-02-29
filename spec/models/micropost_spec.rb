require 'rails_helper'

RSpec.describe Micropost, type: :models do
  context 'micropost' do
    let(:user) { create :tsubasa }
    let(:micropost) { user.microposts.build(content: 'Lorem ipsum') }

    it 'should be valid' do
      expect(micropost).to be_valid
    end

    context 'user id' do
      before do
        micropost.user = nil
      end
      it 'user id should be present' do
        expect(micropost).to_not be_valid
      end
    end

    context 'content present' do
      before do
        micropost.content = ' '
      end
      it 'content should be present' do
        expect(micropost).to_not be_valid
      end
    end
    
    context 'content most 140 characters' do
      before do
        micropost.content = 'a' * 141
      end
      it 'content should be at most 140 characters' do
        expect(micropost).to_not be_valid
      end
    end

    context 'order' do
      let(:microposts) { create :most_recent }
      it 'order should be most recent first' do
        expect(microposts).to eq Micropost.first
      end
    end
  end
end
