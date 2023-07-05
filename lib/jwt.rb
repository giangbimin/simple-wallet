require 'json'
require 'base64'
require 'openssl'

class Jwt
  class << self
    ALGORITHM = 'HS256'.freeze
    HEADER_TYP = 'JWT'.freeze
    DEFAULT_EXPIRATION = 3600
    DEFAULT_REFRESH_EXPIRATION = 86400

    def encode(secret_key, payload = {}, iat = Time.now.to_i + DEFAULT_EXPIRATION)
      header = { alg: ALGORITHM, typ: HEADER_TYP }
      encoded_header = base64_url_encode(header.to_json)
      payload[:iat] = iat
      encoded_payload = base64_url_encode(payload.to_json)
      signature = generate_signature(encoded_header, encoded_payload, secret_key)
      [encoded_header, encoded_payload, signature].join('.')
    end

    def decode(token, secret_key)
      payload = token.split('.')
      return if payload.count != 3
      encoded_header, encoded_payload, signature = payload
      decoded_payload = JSON.parse(base64_url_decode(encoded_payload))
      return unless valid_signature?(encoded_header, encoded_payload, signature, secret_key) && !expired?(decoded_payload)
      decoded_payload
    end

    private

    def base64_url_encode(data)
      Base64.urlsafe_encode64(data).gsub('=', '')
    end

    def base64_url_decode(data)
      data += '=' * (4 - data.length % 4) if data.length % 4 != 0
      Base64.urlsafe_decode64(data)
    end

    def generate_signature(encoded_header, encoded_payload, secret_key)
      signature_input = [encoded_header, encoded_payload].join('.')
      hmac = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA256.new, secret_key, signature_input)
      base64_url_encode(hmac)
    end

    def valid_signature?(encoded_header, encoded_payload, signature, secret_key)
      expected_signature = generate_signature(encoded_header, encoded_payload, secret_key)
      expected_signature == signature
    end

    def expired?(payload)
      expiration = payload['iat']
      expiration && expiration < Time.now.to_i
    end
  end
end
