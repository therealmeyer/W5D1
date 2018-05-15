require 'rails_helper'

RSpec.describe Goal, type: :model do
  let(:user) { User.create(username: 'user', password: 'password')}
  subject(:goal) { Goal.create(title: 'goal', user_id: user.id) }
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:user_id) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:comments) }
  end
end
