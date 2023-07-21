require_relative '../../lib/json_web_token'

class SessionController < ApplicationController

  def create
    user = User.where(email: params[:email]).first
    return render json: { message: 'Authentication failed.'}, status: :unauthorized unless user

    if user.authenticate(params[:password])
      render json: { token: JsonWebToken.encode(user_id: user.id), user_id: user.id,
                     first_name: user.first_name, last_name: user.last_name }, status: :created
    else
      head :unauthorized
    end
  end

end
