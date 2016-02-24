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
