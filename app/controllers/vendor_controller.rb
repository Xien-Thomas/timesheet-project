class VendorController < ApplicationController
  include Authenticate
  # Input vendor name 
  # Return status unauthorized if current user is not an admin
  # Return status unprocessable if vendor name is not a string or nil 
  # Return status created if a new vendor is created
  #
  def create
    if @current_user.is_not_an_admin?
      return render json: nil, status: :unauthorized
    end
    unless params[:vendor_name].is_a? String
      return render json: nil, status: :unprocessable_entity
    end
    if Vendor.create(name: params[:vendor_name].downcase)
      return render json: nil, status: :created
    else 
      return render json: nil, status: :unprocessable_entity
    end
  end
end
