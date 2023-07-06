require 'rails_helper'
require 'jwt'

RSpec.describe AuthenticationService, type: :service do
  let(:user_id) { 1 }
  let(:token) { 'valid_token' }
  let(:refresh_token) { 'valid_refresh_token' }

  before do
    allow(Jwt).to receive(:encode).and_return(token)
    allow(Jwt).to receive(:decode).and_return({ 'user_id' => user_id })
  end

  describe '.generate_jwt' do
    it 'generates a JWT token and stores it in Redis' do
      expect($redis).to receive(:set).with("#{user_id}_jwt", token, ex: AuthenticationService::EXPIRATION)
      jwt = AuthenticationService.generate_jwt(user_id)
      expect(jwt).to eq(token)
    end
  end

  describe '.decode_jwt' do
    context 'when the token is valid and not expired' do
      it 'decodes the JWT token and returns the payload' do
        payload = AuthenticationService.decode_jwt(token)
        expect(payload).to eq({ 'user_id' => user_id })
      end
    end
  end

  describe '.generate_refresh_token' do
    it 'generates a refresh token and stores it in Redis' do
      expect($redis).to receive(:set).with("#{user_id}_refresh_token", token, ex: AuthenticationService::REFRESH_EXPIRATION)
      refresh_token = AuthenticationService.generate_refresh_token(user_id)
      expect(refresh_token).to eq(token)
    end
  end

  describe '.refresh_token_active?' do
    context 'when the refresh token is still active' do
      it 'returns true' do
        allow($redis).to receive(:get).with("#{user_id}_refresh_token").and_return(refresh_token)
        expect(AuthenticationService.refresh_token_active?(user_id, refresh_token)).to be true
      end
    end

    context 'when the refresh token is invalid' do
      it 'returns false' do
        allow($redis).to receive(:get).with("#{user_id}_refresh_token").and_return(nil)
        expect(AuthenticationService.refresh_token_active?(user_id, refresh_token)).to be false
      end
    end
  end

  describe '.inactive_refresh_token' do
    it 'removes the refresh token from Redis' do
      expect($redis).to receive(:del).with("#{user_id}_refresh_token")
      AuthenticationService.inactive_refresh_token(user_id)
    end
  end

  describe '.inactive_jwt' do
    it 'removes the JWT token from Redis' do
      expect($redis).to receive(:del).with("#{user_id}_jwt")
      AuthenticationService.inactive_jwt(user_id)
    end
  end
end
