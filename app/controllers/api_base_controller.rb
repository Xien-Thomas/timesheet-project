class ApiBaseController < ActionController::Base
  include ErrorHandler
  include Authenticate
  skip_before_action :verify_authenticity_token
  protect_from_forgery with: :null_session
end