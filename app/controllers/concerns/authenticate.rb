require_relative '../../../lib/json_web_token'

module Authenticate
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request
    attr_reader :current_user
  end

  private

  def authenticate_request
    Rails.logger.debug("Authentication: Token: #{token}")
    Rails.logger.info('Authentication: Authenticating token')
    token_data = JsonWebToken.decode(token) # Decodes token and obtains user ID
    Rails.logger.debug("Authentication: Current user: #{token_data.inspect}")
    
    if token_data == 'Invalid Token'
      render json: { error: 'Not Authorized' }, status: 401
    elsif token_data == 'Expired Token'
      render json: { error: 'Token is expired. Please login again.' }, status: 401
    else
      @current_user = User.find(token_data['user_id'])
    end
  end

  def token
    request.headers['Authorization'].split(' ').last if request.headers['Authorization'].present?
  end

  def reject_unauthorized_request(message: "You are not authorized to perform this action.")
    render json: { message: message }, status: :unauthorized
  end
  
  def current_user_matches(id)
    @current_user.id == id.to_i
  end
  
  def current_user_matches_params
    @current_user.id == params[:id].to_i
  end
end