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

FactoryGirl.define do
  factory :relationship do
    factory :one do
      association :follower, factory: :tsubasa
      association :followed, factory: :lana
    end

    factory :two do
      association :follower, factory: :tsubasa
      association :followed, factory: :mallory
    end

    factory :three do
      association :follower, factory: :lana
      association :followed, factory: :tsubasa
    end

    factory :four do
      association :follower, factory: :sayami
      association :followed, factory: :tsubasa
    end
  end
end
