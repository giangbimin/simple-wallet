require 'rails_helper'

RSpec.describe PersonalAccount, type: :model do
  let(:user) { User.create(email: 'john@example.com', password: 'password') }
  let(:personal_account) { PersonalAccount.new(user: user) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_one(:wallet) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user_id) }
  end

  describe 'callbacks' do
    it 'creates a wallet after account creation' do
      expect { personal_account.save }.to change(Wallet, :count).by(1)
      expect(personal_account.wallet).to be_present
      expect(personal_account.wallet.entity).to eq(personal_account)
    end
  end
end