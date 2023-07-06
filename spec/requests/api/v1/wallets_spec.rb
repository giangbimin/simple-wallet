require 'rails_helper'

RSpec.describe "Api::V1::Wallets", type: :request do
  describe 'get /api/vi/wallets/:id' do
    let(:first_user) { User.create(email: 'first_user@example.com', password: 'password') }
    let(:second_user) { User.create(email: 'second_user@example.com', password: 'password') }
    let(:personal_account) { create(:personal_account, user_id: first_user.id) }
    let(:team_account) { create(:team_account, user_id: second_user.id) }
    let(:valid_wallet) { personal_account.wallet }
    let(:orther_wallet) { team_account.wallet }
    let(:valid_jwt_token) { AuthenticationService.generate_jwt(first_user.id) }
    let(:invalid_jwt_token) { AuthenticationService.generate_jwt(second_user.id) }

    context 'with valid_jwt_token credentials' do
      before do
        get "/api/v1/wallets/#{valid_wallet.id}", headers: { 'Authorization' => "Bearer #{valid_jwt_token}" }
      end

      it 'returns id and balance' do
        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)['data']
        expect(body['id']).to be_present
        expect(body['balance']).to be_present
      end
    end

    context 'with valid_jwt_token credentials' do
      before do
        get "/api/v1/wallets/11111", headers: { 'Authorization' => "Bearer #{valid_jwt_token}" }
      end

      it 'returns not_found' do
        expect(response).to have_http_status(:not_found)
        body = JSON.parse(response.body)
        expect(body['message']).to eq('Not Found')
      end
    end

    context 'with Authorization id' do
      before do
        get "/api/v1/wallets/#{orther_wallet.id}", headers: { 'Authorization' => "Bearer #{valid_jwt_token}" }
      end
  
      it 'returns unauthorized' do
        expect(response).to have_http_status(:unauthorized)
        body = JSON.parse(response.body)
        expect(body['message']).to eq('Wallet Unauthorized')
      end
    end
  end
end
