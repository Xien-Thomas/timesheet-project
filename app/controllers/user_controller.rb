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
      elsif @current_user.is_an_employee? || (@current_user.is_a_manager? && params[:role_name] != 'Employee')
        return render json: nil, status: :unauthorized
      end
      if User.create(
        first_name: params[:first_name], 
        last_name: params[:last_name], 
        email: params[:email], 
        password: params[:password], 
        vendor_id: params[:vendor_name] ? Vendor.find_by_name(params[:vendor_name]).id : nil, 
        role_id: Role.find_by_name(params[:role_name]).id
      )
        return render json: { message: "User created successfully" }, status: :created
      else
        return render json: nil, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound, NoMethodError
      return render json: nil, status: :unprocessable_entity
    end
  end

  # This is for updating users. 
  # Returns :ok on success, :unprocessable_entity on failure, and :unauthorized if you don't have permission.
  #
  #   Input (all optional): first_name, last_name, password, email, vendor_name, role_name
  #   Output: nil
  #
  def update
    if @current_user.is_an_admin?
      permitted_params = params.permit(:first_name, :last_name, :email, :password)
      begin
        permitted_params[:role_id] = Role.find_by_name(params[:role_name]).id if params[:role_name]
        if params[:vendor_name]
          if params[:vendor_name] == 'null'
            permitted_params[:vendor_id] = nil
          else
            permitted_params[:vendor_id] = Vendor.find_by_name(params[:vendor_name]).id
          end
        end
      rescue NoMethodError
        return render json: { message: 'An error has occured. The specified vendor or role does not exist. The user has not been updated.' }, status: :unprocessable_entity
      end
    elsif @current_user.id.to_s == params[:user_id]
      permitted_params = params.permit(:password)
    else
      return render json: { message: "You are not authorized to update this user" }, status: :unauthorized
    end
    user_to_update = User.find_by_id(params[:user_id])
    if user_to_update
      if user_to_update.update(permitted_params)
        return render json: nil, status: :ok
      else
        return render json: { message: 'An error has occured. The user has not been updated.' }, status: :unprocessable_entity
      end
    else
      return render json: { message: 'The requested user does not exist.' }, status: :unprocessable_entity
    end
  end

  # This is for destroying users. 
  # This will destroy user from database if current user is not an employee
  #
  #   Input: user_id
  #   Output: nil
  #
  def destroy
    if @current_user.is_an_employee?
      return render json: nil, status: :unauthorized 
    end
    user_to_destroy = User.find_by_id(params[:user_id])
    if user_to_destroy
      if @current_user.is_an_admin? || (@current_user.is_a_manager? && user_to_destroy.is_an_employee?)
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
    if @current_user.is_an_employee? && @current_user.id != params[:user_id].to_i
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
    if @current_user.is_an_employee?
      # TODO: redirect to the proper page for an Employee
      return render json: nil, status: :unauthorized
    end
    # If no vendor was specified, return all employees
    # Otherwise, return all employees belonging to that vendor
    if params[:vendor].nil? 
      contractors = User.where(role_id: Role.find_by_name('Employee').id)
      render json: contractors.to_json(only: [:first_name, :last_name, :id])
    else
      contractors = User.where(vendor_id: Vendor.find_by_name(params[:vendor]).id)
      render json: contractors.to_json(only: [:first_name, :last_name, :id])
    end
  end
end
