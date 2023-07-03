class UserController < ApplicationController
  include Authenticate
  def create
  end

  def update
  end

  def destroy
  end

  def show
  end

  # This is the basis of "View Contractors". This will return all contractors with the given vendor
  # If no vendor is specified, it will return all contractors.
  #
  #   Input: Vendor name (optional)
  #   Output: List of contractors
  #
  def index
    if @current_user.role["name"] == 'Employee'
      # TODO: redirect to the proper page for an Employee
      return render json: nil, status: :unauthorized
    end
    # If no vendor was specified, return all employees
    # Otherwise, return all employees belonging to that vendor
    if params[:vendor].nil? 
      contractors = User.where(role: Role.where(name: 'Employee').first[:id])
      render json: contractors.to_json(only: [:first_name, :last_name, :id])
    else
      contractors = User.where(vendor_id: Vendor.where(name: params[:vendor].downcase).first[:id])
      render json: contractors.to_json(only: [:first_name, :last_name, :id])
    end
  end
end
