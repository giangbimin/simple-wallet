require 'rails_helper'

RSpec.describe "Api::V1::Transactions", type: :request do
  let(:first_user) { User.create(email: 'first_user@example.com', password: 'password') }
  let(:valid_jwt_token) { AuthenticationService.generate_jwt(first_user.id) }
  let(:first_user_req_header) {{ 'Authorization' => "Bearer #{valid_jwt_token}" }}
  let(:personal_account) { create(:personal_account, user_id: first_user.id) }
  let(:first_wallet) { personal_account.wallet }
  let(:second_user) { User.create(email: 'second_user@example.com', password: 'password') }
  let(:second_user_jwt_token) { AuthenticationService.generate_jwt(second_user.id) }
  let(:second_user_req_header) {{ 'Authorization' => "Bearer #{second_user_jwt_token}" }}
  let(:team_account) { create(:team_account, user_id: second_user.id) }
  let(:second_wallet) { team_account.wallet }
  before do
    create(:transaction, source_wallet_id: nil, target_wallet_id: first_wallet.id, amount: 100, skip_wallet_id_validate: true)
    create(:transaction, source_wallet_id: nil, target_wallet_id: second_wallet.id, amount: 100, skip_wallet_id_validate: true)
  end
  
  describe "GET /api/v1/transactions/:id" do
    context "when the transaction exists" do
      let(:transaction){ create(:transaction, source_wallet_id: second_wallet.id, target_wallet_id: first_wallet.id, amount: 1) }
      before do
        get "/api/v1/transactions/#{transaction.id}", headers: first_user_req_header
      end
      it "returns the transaction data" do
        expect(response).to have_http_status(:ok)
        expect(json_response["data"]["id"]).to eq(transaction.id)
        expect(json_response["data"]["source_wallet_id"]).to eq(transaction.source_wallet_id)
        expect(json_response["data"]["target_wallet_id"]).to eq(transaction.target_wallet_id)
        expect(json_response["data"]["amount"]).to eq(transaction.amount)
      end
    end
    
    context "when the transaction does not exist" do
      before do
        get "/api/v1/transactions/11111", headers: first_user_req_header
      end
      it "returns a not found error" do
        expect(response).to have_http_status(:not_found)
        expect(json_response["message"]).to eq("Not Found")
      end
    end
  end

  describe "POST /api/v1/wallets/:wallet_id/transactions" do
    let(:valid_params) {{ target_wallet_id: second_wallet.id, amount: 1}}
    let(:not_found_params) {{ target_wallet_id: 11111, amount: 1}}
    let(:out_of_amount_params) {{ target_wallet_id: second_wallet.id, amount: 1000}}
  
    context "when the wallet and parameters are valid" do
      before do
        post "/api/v1/wallets/#{first_wallet.id}/transactions", headers: first_user_req_header, params: valid_params
      end
      it "creates a new transaction" do
        expect(response).to have_http_status(:created)
        expect(json_response["message"]).to eq("Created")
        expect(json_response["data"]["source_wallet_id"]).to eq(first_wallet.id)
        expect(json_response["data"]["target_wallet_id"]).to eq(valid_params[:target_wallet_id])
        expect(json_response["data"]["amount"]).to be_present
      end
    end
    
    context "when the wallet is unauthorized" do
      before do
        post "/api/v1/wallets/#{first_wallet.id}/transactions", headers: second_user_req_header, params: valid_params
      end
      it "returns an unauthorized error" do
        expect(response).to have_http_status(:unauthorized)
        expect(json_response["message"]).to eq("Wallet Unauthorized")
      end
    end
    
    context "when the target wallet not_found" do
      before do
        post "/api/v1/wallets/#{first_wallet.id}/transactions", headers: first_user_req_header, params: not_found_params
      end
      it "returns a not acceptable error" do
        expect(response).to have_http_status(:not_acceptable)
        expect(json_response["message"]).to eq(["Target wallet must exist", "Target wallet Not Found"])
      end
    end

    context "when the source wallet out of balance" do
      before do
        post "/api/v1/wallets/#{first_wallet.id}/transactions", headers: first_user_req_header, params: out_of_amount_params
      end
      it "returns a not acceptable error" do
        expect(response).to have_http_status(:not_acceptable)
        expect(json_response["message"]).to eq(["Amount Out of balance"])
      end
    end
  end
end
