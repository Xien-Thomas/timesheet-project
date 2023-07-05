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

  # this is the basis of "View Contractors", this will view contractors UNDER the vendor in question
  # input is just be the vendor's info
  # output is just the contractor(s) under the given vendor
  def index
    # T - we're going to grab the vendor info from the url (ie that will be our params)

  end
end
