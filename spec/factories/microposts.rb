FactoryGirl.define do
  factory :micropost do
    content { Faker::Lorem.sentence(5) }
    created_at 42.days.ago
    association :user, factory: :tsubasa

    factory :orange do
      content "I just ate an orange"
      created_at 10.minutes.ago
      association :user, factory: :tsubasa
    end

    factory :tau_mainfesto do
      content "Check out the @tauday site by @mhartl: http://tauday.com"
      created_at 3.years.ago
      association :user, factory: :tsubasa
    end

    factory :cat_video do
      content "Sad cats are sad: http://youtu.be/PKffm2uI4dk"
      created_at 2.hours.ago
      association :user, factory: :tsubasa
    end

    factory :most_recent do
      content "writing a short test"
      created_at Time.zone.now
      association :user, factory: :tsubasa
    end

    factory :ants do
      content "Oh, is that what you want? Because that's how you get ants!"
      created_at 2.years.ago
      association :user, factory: :sayami
    end

    factory :zone do
      conten "Danger zone!"
      created_at 3.days.ago
      association :user, factory: :sayami
    end

    factory :tone do
      content "I'm sorry. Your words made sense, but your sarcastic tone did not."
      created_at 10.minutes.ago
      association :user, factory: :lana
    end

    factory :van do
      content "Dude, this van's, like, rolling probable cause."
      created_at 4.hours.ago
      association :user, factory: :lana
    end
  end
end
