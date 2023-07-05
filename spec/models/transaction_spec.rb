require 'rails_helper'
RSpec.describe Transaction, type: :model do
  describe "associations" do
    it { should belong_to(:source_wallet).with_foreign_key(:source_wallet_id).class_name('Wallet').optional(true) }
    it { should belong_to(:target_wallet).with_foreign_key(:target_wallet_id).class_name('Wallet') }
  end

  describe 'validations' do
    subject { build(:transaction) }
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
    context 'when skip_wallet_id_validate is true' do
      before { subject.skip_wallet_id_validate = true }
      context 'when both source_wallet_id and target_wallet_id are blank' do
        before do
          subject.source_wallet_id = nil
          subject.target_wallet_id = nil
        end
        it { is_expected.to validate_presence_of(:source_wallet_id) }
        it { is_expected.to validate_presence_of(:target_wallet_id) }
      end

      context 'when target_wallet_id is present' do
        before {subject.target_wallet_id = 1 }
        it { is_expected.not_to validate_presence_of(:source_wallet_id) }
      end
    end
  end

  describe "transfer_validation" do
    let(:personal_account) { create(:personal_account)  }
    let(:source_wallet) { personal_account.wallet }
    let(:stock_account) { create(:stock_account)  }
    let(:target_wallet) { stock_account.wallet }
    let(:transaction) { FactoryBot.build(:transaction, amount: 40, source_wallet_id: source_wallet.id, target_wallet_id: target_wallet.id) }

    context "when source wallet has sufficient balance" do
      before do
        allow(transaction).to receive(:source_wallet).and_return(source_wallet)
        allow(source_wallet).to receive(:balance).and_return(50)
        transaction.valid?
      end

      it "does not add an error to the amount attribute" do
        expect(transaction.errors[:amount]).to be_empty
      end
    end

    context "when source wallet does not have sufficient balance" do
      before do
        allow(transaction).to receive(:source_wallet).and_return(source_wallet)
        allow(source_wallet).to receive(:balance).and_return(30)
        transaction.valid?
      end

      it "adds an error to the amount attribute" do
        expect(transaction.errors[:amount]).to include("Out of balance")
      end
    end
  end
end