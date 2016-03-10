# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_relationships_on_followed_id                  (followed_id)
#  index_relationships_on_follower_id                  (follower_id)
#  index_relationships_on_follower_id_and_followed_id  (follower_id,followed_id) UNIQUE
#

require 'rails_helper'

RSpec.describe Relationship, type: :models do
  context 'relationship' do
    let(:relationship) { Relationship.new(follower_id: 1, followed_id: 2) }
    it 'should be valid' do
      expect(relationship).to be_valid
    end
    context 'follower id' do
      before do
        relationship.follower_id = nil
      end
      it 'should require a follower_id' do
        expect(relationship).to_not be_valid
      end
    end
    context 'followed id' do
      before do
        relationship.followed_id = nil
      end
      it 'should require a followed_id' do
        expect(relationship).to_not be_valid
      end
    end
  end
end
