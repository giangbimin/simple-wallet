require 'rails_helper'

RSpec.describe "Api::V1::PersonalAccounts", type: :request do
  let(:user) { User.create(email: 'test@example.com', password: 'password') }
  describe "Post /api/v1/personal_accounts" do
    let(:jwt_token) { AuthenticationService.generate_jwt(user.id) }
    context 'with valid credentials' do
      before do
        post '/api/v1/personal_accounts', params: {name: "personal_accounts"}, headers: { 'Authorization' => "Bearer #{jwt_token}" }
      end
      it 'returns a JWT token and refresh token' do
        expect(response).to have_http_status(:created)
        body = JSON.parse(response.body)
        expect(body['message']).to eq('Created')
        expect(body['data']['id']).to be_present
        expect(body['data']['name']).to be_present
        expect(body['data']['wallet_id']).to be_present
      end
    end
  end
end
