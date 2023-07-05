require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#validations' do
    it { should validate_presence_of(:email) }
    it { should allow_value('test@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) }
  end

  describe '#associations' do
    it { should have_many(:personal_accounts) }
    it { should have_many(:stock_accounts) }
    it { should have_many(:team_accounts) }
  end

  describe '#authenticate?' do
    let(:user) { User.create(email: 'test@example.com', password: 'password') }

    it 'returns true if the password is correct' do
      expect(user.authenticate?('password')).to eq(true)
    end

    it 'returns false if the password is incorrect' do
      expect(user.authenticate?('wrong_password')).to eq(false)
    end
  end
end
