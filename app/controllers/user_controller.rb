class UserController < ApplicationController
  include Authenticate
  
  # This is for creating new users. 
  # Returns :created on success, :unprocessable_entity on failure, and :unauthorized if you don't have permission.
  #
  #   Input: first_name, last_name, password, email, vendor_name (optional), role_name
  #   Output: nil
  #
  def create
    begin
      if params[:role_name].nil? || params[:first_name].nil? || params[:last_name].nil? || params[:email].nil? || params[:password].nil? 
        return render json: nil, status: :unprocessable_entity
      elsif @current_user.role['name'] == 'Employee' || (@current_user.role['name'] == 'Manager' && params[:role_name] != 'Employee')
        return render json: nil, status: :unauthorized
      end
      if User.create!(
        first_name: params[:first_name], 
        last_name: params[:last_name], 
        email: params[:email], 
        password: params[:password], 
        vendor_id: params[:vendor_name] ? Vendor.where(name: params[:vendor_name].downcase).first[:id] : nil, 
        role_id: Role.where(name: params[:role_name]).first[:id]
      )
        return render json: {message: "User created successfully"}, status: :created
      else
        return render json: nil, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound, NoMethodError
      return render json: nil, status: :unprocessable_entity
    end
  end

  def update
  end
# This is for destroying users. 
  # This will destroy user from database if current user is not an employee
  #   Input: user_id
  #
  def destroy
    if @current_user.role.name == 'Employee'
      return render json: nil, status: :unauthorized 
    end
    user_to_destroy = User.where(id: params[:user_id]).first
    if user_to_destroy
      if @current_user.role.name == 'Admin' || (@current_user.role.name == 'Manager' && user_to_destroy.role.name == 'Employee')
        if user_to_destroy.destroy
          return render json: nil, status: :ok
        else
          return render json: { message: "Failed to delete user." }, status: 500 
        end
      else
        return render json: nil, status: :unauthorized 
      end
    else 
      return render json: nil, status: :unprocessable_entity
    end
  end

  # This is for viewing individual contractors. 
  # This will return all information about a contractor with the given user_id.
  #
  #   Input: user_id
  #   Output: first_name, last_name, email, id, vendor_name (can be nil), role_name
  #
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
