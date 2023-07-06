require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { User.create(email: 'test@example.com', password: 'password') }
  let(:valid_credentials) { { email: 'test@example.com', password: 'password' } }
  let(:invalid_credentials) { { email: 'test@example.com', password: 'wrong_password' } }

  describe 'POST /signin' do
    context 'with valid credentials' do
      it 'returns a JWT token and refresh token' do
        post '/signin', params: valid_credentials
        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body['message']).to eq('Sign in successful')
        expect(body['user_id']).to be_present
        expect(body['token']).to be_present
        expect(body['refresh_token']).to be_present
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized' do
        user
        post '/signin', params: invalid_credentials
        expect(response).to have_http_status(:unauthorized)
        body = JSON.parse(response.body)
        expect(body['message']).to eq('Invalid credentials')
      end
    end
  end

  describe 'POST /refresh' do
    let(:jwt_token) { AuthenticationService.generate_jwt(user.id) }
    let(:refresh_token) { AuthenticationService.generate_refresh_token(user.id) }

    context 'with valid refresh token' do
      it 'returns a new JWT token and refresh token' do
        post '/refresh', params: {refresh_token: refresh_token }
        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body['message']).to eq('Refresh successful')
        expect(body['user_id'].to_i).to eq(user.id)
      end
    end

    context 'with invalid refresh token' do
      it 'returns unauthorized' do
        post '/refresh', params: { refresh_token: 'invalid_refresh_token' }
        expect(response).to have_http_status(:unauthorized)
        body = JSON.parse(response.body)
        expect(body['message']).to eq('Invalid credentials of refresh_token')
      end
    end
  end

  describe 'DELETE /signout' do
    let(:jwt_token) { AuthenticationService.generate_jwt(user.id) }

    before do
      delete '/signout', headers: { 'Authorization' => "Bearer #{jwt_token}" }
    end

    it 'destroys the JWT token and refresh token' do
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['message']).to eq('Sign out successful')
    end
  end

end
