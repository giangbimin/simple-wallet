require 'json'
require 'jwt'

RSpec.describe Jwt do
  let(:secret_key) { "Test" }
  let(:payload) { { user_id: 1 } }
  let(:iat) { Time.now.to_i + 12800 }

  describe '.encode' do
    it 'encodes a payload into a JWT token' do
      token = Jwt.encode(secret_key, payload, iat)
      expect(token).to be_a(String)
    end
  end

  describe '.decode' do
    it 'decodes a JWT token and returns the payload' do
      token = Jwt.encode(secret_key, payload, iat)
      decoded_payload = Jwt.decode(token, secret_key)
      expect(decoded_payload["user_id"]).to eq(payload[:user_id])
    end

    it 'returns nil for an invalid token' do
      token = 'invalid_token'
      decoded_payload = Jwt.decode(token, secret_key)
      expect(decoded_payload).to be_nil
    end

    it 'returns nil for an expired token' do
      expired_token = Jwt.encode(secret_key, payload, 0)
      decoded_payload = Jwt.decode(expired_token, secret_key)
      expect(decoded_payload).to be_nil
    end
  end
end
