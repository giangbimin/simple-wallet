require 'rails_helper'

RSpec.describe AssetTransferService do
  let(:first_user) { User.create(email: 'first_user@example.com', password: 'password') }
  let(:personal_account) { create(:personal_account, user_id: first_user.id) }
  let(:first_wallet) { personal_account.wallet }
  let(:second_user) { User.create(email: 'second_user@example.com', password: 'password') }
  let(:team_account) { create(:team_account, user_id: second_user.id) }
  let(:second_wallet) { team_account.wallet }
  let(:transaction_params) { { target_wallet_id: second_wallet.id, amount: 10 } }
  before do
    create(:transaction, source_wallet_id: nil, target_wallet_id: first_wallet.id, amount: 100, skip_wallet_id_validate: true)
    create(:transaction, source_wallet_id: nil, target_wallet_id: second_wallet.id, amount: 100, skip_wallet_id_validate: true)
  end
  
  describe "#execute" do
    context "when the transaction is created successfully" do
      let(:transaction){ create(:transaction, source_wallet_id: second_wallet.id, target_wallet_id: first_wallet.id, amount: 1) }
      it "returns a success response" do
        service = AssetTransferService.new(first_wallet, transaction_params)
        expect {
          response = service.execute
          expect(response[:status]).to eq(true)
          expect(response[:message]).to eq("Created")
          expect(response[:transaction]).to be_a(Transaction)
        }.to change(Transaction, :count).by(1)
      end

      it "updates the current wallet's timestamp" do
        service = AssetTransferService.new(first_wallet, transaction_params)
        expect {
          service.execute
          first_wallet.reload
        }.to change(first_wallet, :updated_at)
      end
    end

    context "when the transaction fails to create" do
      let(:invalid_params) { { target_wallet_id: second_wallet.id, amount: -100 } }

      it "returns an error response" do
        service = AssetTransferService.new(first_wallet, invalid_params)
        response = service.execute
        expect(response[:status]).to eq(false)
        expect(response[:message]).to include("Amount must be greater than 0")
      end

      it "does not create a new transaction" do
        expect {
          service = AssetTransferService.new(first_wallet, invalid_params)
          service.execute
        }.not_to change(Transaction, :count)
      end
    end

    context "when an ActiveRecord error occurs" do
      let(:invalid_params) { { target_wallet_id: second_wallet.id, amount: 200 } }
      it "returns an error Amount Out of balance" do
        service = AssetTransferService.new(first_wallet, invalid_params)
        response = service.execute
        expect(response[:status]).to eq(false)
        expect(response[:message]).to include("Amount Out of balance")
      end

      it "does not create a new transaction" do
        expect {
          service = AssetTransferService.new(first_wallet, invalid_params)
          allow_any_instance_of(Transaction).to receive(:save!).and_raise(ActiveRecord::RecordInvalid)
          service.execute
        }.not_to change(Transaction, :count)
      end
    end
  end
end
