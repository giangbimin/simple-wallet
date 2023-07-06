require 'jwt'

class AuthenticationService
  EXPIRATION = 3600
  REFRESH_EXPIRATION = 86400

  def self.generate_jwt user_id
    payload = {user_id: user_id}
    iat = Time.now.to_i + EXPIRATION
    payload[:iat] = iat
    jwt = Jwt.encode(ENV["SECRECT_KEY"], payload, iat)
    $redis.set("#{user_id}_jwt", jwt, ex: EXPIRATION)
    jwt
  end

  def self.generate_refresh_token user_id
    payload = {user_id: user_id}
    iat = Time.now.to_i + REFRESH_EXPIRATION
    payload[:iat] = iat
    refresh_token = Jwt.encode(ENV["SECRECT_KEY"], payload, iat)
    $redis.set("#{user_id}_refresh_token", refresh_token, ex: REFRESH_EXPIRATION)
    refresh_token
  end

  def self.decode_jwt token
    Jwt.decode(token, ENV["SECRECT_KEY"])
  end

  def self.jwt_active? user_id, token
    $redis.get("#{user_id}_jwt") == token
  end

  def self.refresh_token_active? user_id, refresh_token
    $redis.get("#{user_id}_refresh_token") == refresh_token
  end

  def self.inactive_refresh_token user_id
    $redis.del("#{user_id}_refresh_token")
  end

  def self.inactive_jwt user_id
    $redis.del("#{user_id}_jwt")
  end
end
