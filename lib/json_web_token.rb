# frozen_string_literal: true

class JsonWebToken
  def self.encode(payload)
    payload[:exp] = 24.hour.from_now.to_i
    JWT.encode(payload, Rails.application.secret_key_base, 'HS256')
  end

  def self.decode(token)
    Rails.logger.info('JSON Web Token: Decoding token')
    JWT.decode(token, Rails.application.secret_key_base, true, { algorithm: 'HS256' })[0]
  rescue JWT::ExpiredSignature, JWT::VerificationError => e
    return 'Expired Token'
  rescue JWT::DecodeError, JWT::VerificationError => e
    return 'Invalid Token'
  end
end