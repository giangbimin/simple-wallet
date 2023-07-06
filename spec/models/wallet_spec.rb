require 'rails_helper'

RSpec.describe Wallet, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:entity_id) }
    it { is_expected.to validate_presence_of(:entity_type) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:entity) }
    it { is_expected.to have_many(:withdrawals).class_name('Transaction').with_foreign_key('source_wallet_id') }
    it { is_expected.to have_many(:deposits).class_name('Transaction').with_foreign_key('target_wallet_id') }
  end

  describe '#balance' do
    let(:personal_account) { create(:personal_account) }
    let(:team_account) { create(:team_account) }
    let(:wallet) { personal_account.wallet }
    let(:target_wallet) { team_account.wallet }

    it 'returns the correct balance' do
      create(:transaction, target_wallet_id: wallet.id, amount: 100, skip_wallet_id_validate: true)
      create(:transaction, target_wallet_id: wallet.id, amount: 100, skip_wallet_id_validate: true)
      create(:transaction, source_wallet_id: wallet.id, target_wallet_id: target_wallet.id, amount: 50)
      expect(wallet.balance).to eq(150)
    end

    it 'returns 0 when there are no deposits or withdrawals' do
      expect(wallet.balance).to eq(0)
    end
  end
end