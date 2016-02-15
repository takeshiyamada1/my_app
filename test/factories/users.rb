FactoryGirl.define do

  factory :user do
    sequence :name do |n|
      "User #{n}"
    end
    sequence :email do |n|
      "user-#{n}@example.com"
    end
    password 'password'
    password_confirmation 'password'
    activated true
    activated_at Time.zone.now
    initialize_with { User.find_or_create_by(email: email) }

    factory :tsubasa do
      name 'Tsubasa Ryuto'
      email 'tsubasa@example.com'
      password_digest User.digest('password')
      admin true
      activated true
      activated_at Time.zone.now

      factory :tsubasa_with_microposts do
        after :create do |user|
          create :orange, user: user
          create :tau_manifesto, suer: user
          create :cat_video, user: user
          create :most_recent, user: user
          create_list :micropost, 30, user: user
        end
      end
    end

    factory :sayami do
      name 'Sayami Yoshida'
      email 'sayami@example.com'
      password_digest User.digest('password')
      activated true
      activated_at Time.zone.now

      factory :sayami_with_microposts do
        after :create do |user|
          create :ants, user: user
          create :zone, user: user
        end
      end
    end

    factory :lana do
      name 'Lana kane'
      email 'hands@example.gov'
      password_digest User.digest('password')
      activated true
      activated_at Time.zone.now

      factory :lana_with_microposts do
        after :create do |user|
          create :tone, user: user
          create :van, user: userds
        end
      end
    end

    factory :mallory do
      name 'Mallory Archer'
      email 'boss@example.gov'
      password_digest User.digest('password')
      activated true
      activated_at Time.zone.now
    end
  end
end

    