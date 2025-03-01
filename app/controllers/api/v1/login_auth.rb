module Api::V1::LoginAuth
  extend ActiveSupport::Concern

  JWT_EXPIRATION_TIME = 8.hours

  def token_secret_signature_key
    Rails.application.secrets.secret_key_base
  end

  def extract_token
    request.headers['Authorization']&.split&.last
  end

  def decode_jwt(token)
    JWT.decode token, token_secret_signature_key, true, { algorithm: 'HS256' }
  end

  def generate_jwt(payload)
    exp_payload = { data: payload, exp: Time.now.to_i + JWT_EXPIRATION_TIME }
    JWT.encode exp_payload, token_secret_signature_key, 'HS256'
  end
end
