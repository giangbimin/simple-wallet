require 'jwt'

class AuthenticationService
  EXPIRATION = 3600
  REFRESH_EXPIRATION = 86400

  def self.generate_jwt user_id
    payload = {user_id: user_id}
    iat = Time.now.to_i + EXPIRATION
    jwt = Jwt.encode(ENV["SECRECT_KEY"], payload, iat)
    $redis.set("#{user_id}_jwt", jwt, ex: EXPIRATION)
    jwt
  end

  def self.decode_jwt token
    payload = Jwt.decode(token, ENV["SECRECT_KEY"])
    return unless payload
    user_id = payload["user_id"]
    return if $redis.get("#{user_id}_jwt") != token
    payload
  end

  def self.generate_refresh_token user_id
    refresh_token = SecureRandom.urlsafe_base64(24)
    $redis.set("#{user_id}_refresh_token", refresh_token, ex: REFRESH_EXPIRATION)
    refresh_token
  end

  def self.refresh_token_valid? user_id, refresh_token
    $redis.get("#{user_id}_refresh_token") == refresh_token
  end

  def self.inactive_refresh_token user_id
    $redis.del("#{user_id}_refresh_token")
  end

  def self.inactive_jwt user_id
    $redis.del("#{user_id}_jwt")
  end
end
