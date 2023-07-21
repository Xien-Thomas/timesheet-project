module ErrorHandler
  extend ActiveSupport::Concern

  def self.included(klass)
    klass.class_eval do
      rescue_from StandardError, with: :standard_error if Rails.env.production?
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found if Rails.env.production?
    end
  end

  private

  def record_not_found(error)
    render json: { message: "An error has occured. Please ensure that your request parameters are valid." }, status: :unprocessable_entity
  end
  
  def standard_error(error)
    render json: { message: "An error has occured." }, status: 500
  end
end