class UserController < ApplicationController
  include Authenticate
  def create
  end

  def update
  end

  def destroy
  end

  def show
    if @current_user.role['name'] == 'Employee' && @current_user.id != params[:user_id].to_i
      return render json: nil, status: :unauthorized
    end
    begin 
      if User.find_by_id(params[:user_id]).vendor.nil?
        desired_user = User.select('users.*, roles.name as role_name').joins(:role).where(id: params[:user_id]).first
      else
        desired_user = User.select('users.*, vendors.name as vendor_name, roles.name as role_name').joins(:vendor, :role).where(id: params[:user_id]).first
      end
    rescue NoMethodError
      return render json: nil, status: :unprocessable_entity
    end
    return render json: desired_user.to_json(only: [:first_name, :last_name, :email, :id, :vendor_name, :role_name]), status: :ok
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
