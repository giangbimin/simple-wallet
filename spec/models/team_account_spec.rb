require 'rails_helper'

RSpec.describe TeamAccount, type: :model do
  let(:user) { User.create(email: 'john@example.com', password: 'password') }
  let(:team_account) { TeamAccount.new(user: user) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_one(:wallet) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user_id) }
  end

  describe 'callbacks' do
    it 'creates a wallet after account creation' do
      expect { team_account.save }.to change(Wallet, :count).by(1)
      expect(team_account.wallet).to be_present
      expect(team_account.wallet.entity).to eq(team_account)
    end
  end
end