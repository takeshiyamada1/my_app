require 'rails_helper'

RSpec.describe User, type: :models do
  context 'user' do
    let(:name) { 'Example User' }
    let(:email) { 'user@example.com' }
    let(:password) { 'password' }
    let(:password_confirmation) { 'password' }
    let(:user) { User.new(name: name, email: email, password: password, password_confirmation: password_confirmation) }

    it 'should be valid' do
      expect(user).to be_valid
    end

    context 'name' do
      context 'present' do
        let(:name) { '' }
        it 'name should be present' do
          expect(user).to be_invalid
        end
      end

      context 'too long' do
        let(:name) { 'a' * 51 }
        it 'name should not be too long' do
          expect(user).to be_invalid
        end
      end
    end

    context 'email' do
      context 'present' do
        let(:email) { '' }
        it 'email should be present' do
          expect(user).to be_invalid
        end
      end

      context 'too long' do
        let(:email) { 'a' * 244 + '@example.com' }
        it 'email should not be too long' do
          expect(user).to be_invalid
        end
      end

      context 'accept valid addresses' do
        let(:valid_addresses) { ['user@example.com', 'USER@foo.COM', 'A_US-ER@foo.bar.org', 'first.last@foo.jp', 'alice+bob@baz.cn'] }
        it 'email validation should accept valid addresses' do
          valid_addresses.each do |valid_address|
            user.email = valid_address
            expect(user).to be_valid, "#{valid_address.inspect} should be valid"
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
          expect(duplicate_user).to be_invalid
        end
      end
    end

    context 'pssowrd present' do
      let(:password) { 'a' * 5 }
      let(:password_confirmation) { 'a' * 5 }
      it 'password should be present (nonblank)' do
        expect(user).to be_invalid
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
          expect(tsubasa.feed.include?(post_unfollowed)).to be_falsey
        end
      end
    end
  end
end
