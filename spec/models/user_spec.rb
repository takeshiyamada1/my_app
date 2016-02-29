require 'rails_helper'

RSpec.describe User, type: :models do
  context 'user' do
    let(:user) { User.new(name: 'Example User', email: 'user@example.com', password: 'password', password_confirmation: 'password') }

    it 'should be valid' do
      expect(user).to be_valid
    end

    context 'name' do
      context 'present' do
        before do
          user.name = ''
        end
        it 'name should be present' do
          expect(user).to_not be_valid
        end
      end

      context 'too long' do
        before do
          user.name = 'a' * 51
        end
        it 'name should not be too long' do
          expect(user).to_not be_valid
        end
      end
    end

    context 'email' do
      context 'present' do
        before do
          user.email = ''
        end
        it 'email should be present' do
          expect(user).to_not be_valid
        end
      end

      context 'too long' do
        before do
          user.email = 'a' * 244 + '@example.com'
        end
        it 'email should not be too long' do
          expect(user).to_not be_valid
        end
      end

      context 'accept valid addresses' do
        let(:valid_addresses) { ['user@example.com', 'USER@foo.COM', 'A_US-ER@foo.bar.org', 'first.last@foo.jp', 'alice+bob@baz.cn'] }
        it 'email validation should accept valid addresses' do
          valid_addresses.each do |valid_address|
            user.email = valid_address
            expect(user).to be_valid, '#{valid_address.inspect} should be valid'
          end
        end
      end

      context 'unique' do
        let(:duplicate_user) { user.dup }
        before do
          duplicate_user.email = user.email.upcase
          user.save
        end
        it 'email addresses should be unique' do
          expect(duplicate_user).to_not be_valid
        end
      end
    end

    context 'pssowrd present' do
      before do
        user.password = user.password_confirmation = 'a' * 5
      end
      it 'password should be present (nonblank)' do
        expect(user).to_not be_valid
      end
    end

    it 'authenticated? should return false for a user with nil digest' do
      expect(user).to_not be_authenticated(:remember, '')
    end

    context 'microposts destroyed' do
      before do
        user.save
        user.microposts.create!(content: 'Lorem ipsum')
      end
      it 'associated microposts should be destroyed' do
        expect { user.destroy }.to change { Micropost.count }.by(-1)
      end
    end

    context 'follow and unfollow' do
      let(:tsubasa) { create :tsubasa }
      let(:lana) { create :lana }
      it 'should follow and unfollow a user' do
        expect(tsubasa).to_not be_following(lana)
        tsubasa.follow(lana)
        expect(tsubasa).to be_following(lana)
        expect(lana.followers.include?(tsubasa)).to be_truthy
        tsubasa.unfollow(lana)
        expect(tsubasa).to_not be_following(lana)
      end
    end

    context 'right posts' do
      let(:tsubasa) { create :tsubasa }
      let(:sayami) { create :sayami }
      let(:lana) { create :lana }

      it 'feed should have the right posts' do
        sayami.microposts.each do |post_following|
          expect(tsubasa.feed.include?(post_following)).to be_truthy
        end

        tsubasa.microposts.each do |post_self|
          expect(tsubasa.feed.include?(post_self)).to be_truthy
        end

        # フォローしていないユーザーの投稿を確認
        lana.microposts.each do |post_unfollowed|
          expect(tsubasa.feed.include?(post_unfollowed)).to_not be_truthy
        end
      end
    end
  end
end