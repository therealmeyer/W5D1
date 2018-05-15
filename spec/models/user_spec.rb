require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { User.create(username: 'user', password: 'password') }
  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_length_of(:password).is_at_least(6) }
  end

  describe 'session_token' do
    it 'assigns a session token if one is not given' do
      user1 = User.create(username: 'username', password: 'password')
      expect(user1.session_token).not_to be_nil
    end
  end

  describe 'associations' do
    it { should have_many(:goals) }
    it { should have_many(:comments) }
  end

  describe 'User::find_by_credentials' do
    context 'valid credentials' do
      it 'should return the correct user' do
        user1 = User.create(username: 'username', password: 'password')
        expect(User.find_by_credentials('username', 'password')).to eq(user1)
      end
    end

    context 'invalid credentials' do
      it 'should return nil' do
        expect(User.find_by_credentials('user1', 'password1')).to be_nil
      end
    end
  end

  describe 'user#password=(password)' do
    it 'should set the password instance variable' do
      user.password = 'new_password'
      expect(user.password).to eq('new_password')
    end

    it 'should set the password digest' do
      digest = user.password_digest
      user.password = 'new_password'
      expect(user.password_digest).not_to eq(digest)
    end
  end

  describe 'user#is_password?' do
    it 'compares the password to password_digest' do
      expect(user.is_password?('password')).to eq(true)
    end
  end

  describe 'password encryption' do
    it 'does not save password to db' do
      User.create(username: 'user', password: 'password')
      user1 = User.find_by(username: 'user')
      expect(user1.password).not_to be('password')
    end

    it 'encrypts password via BCrypt' do
      expect(BCrypt::Password).to receive(:create).with('password')
      User.create(username: 'user', password: 'password')
    end
  end


end
