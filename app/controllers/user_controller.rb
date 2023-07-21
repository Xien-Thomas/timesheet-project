class UserController < ApiBaseController
  # This is for creating new users. 
  # 
  # It expects json that looks like this:
  #
  # {
  #   "user": {
  #     "first_name": "Chino",
  #     "last_name": "Kafuu",
  #     "email": "email@example.com",
  #     "password": "thisisapassword",
  #     "role": "employee",
  #     "vendor_id": 1
  #   }
  # }
  #
  def create
    return reject_unauthorized_request unless @current_user.admin?

    user_to_create = User.new user_params
    if user_to_create.save
      Timesheet.create(user_id: user_to_create.id) if user_to_create.employee?
      return render json: { message: "User successfully created." }, status: :created
    else
      return render json: { message: user_to_create.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  # This is for updating users. 
  # 
  # Employees can update their password.
  # Admins can update everything.
  # 
  # It expects json that looks like this:
  #
  # {
  #   "user": {
  #     "first_name": "Chino",
  #     "last_name": "Kafuu",
  #     "email": "email@example.com",
  #     "password": "thisisapassword",
  #     "role": "employee",
  #     "vendor_id": 1
  #   }
  # }
  #
  def update
    return reject_unauthorized_request unless @current_user.admin? || current_user_matches_params

    user_to_update = User.find params[:id]
    if @current_user.admin?
      if user_to_update.update user_params
        return render json: { message: "User successfully updated." }, status: :ok
      else
        return render json: { message: user_to_update.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    else
      if user_to_update.update user_restricted_params
        return render json: { message: "User successfully updated." }, status: :ok
      else
        return render json: { message: user_to_update.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    end
  end

  # This is for destroying users. 
  # Only admins are authorized to use this method.
  #
  def destroy
    return reject_unauthorized_request unless @current_user.admin?

    user_to_destroy = User.find params[:id]
    if user_to_destroy.destroy
      return render json: { message: "User successfully deleted."}, status: :ok
    else
      return render json: { message: user_to_destroy.errors.full_messages.join(', ') }, status: 500 
    end
  end

  # This is for viewing individual contractors. 
  # 
  # It returns json that looks like this:
  #
  # {
  #   "user": {
  #     "id": 1,
  #     "first_name": "Test1",
  #     "last_name": "User1",
  #     "email": "test1@example.com",
  #     "vendor_id": 21,
  #     "role": "employee"
  #   }
  # }
  #
  def show
    return reject_unauthorized_request if @current_user.employee? && !current_user_matches_params

    desired_user = User.find params[:id]
    render json: desired_user.to_json(only: [:first_name, :last_name, :email, :id, :vendor_id, :role]), status: :ok
  end


  # This is for viewing all contractors. 
  # You may specify a vendor_id to filter results. (ex: /user?vendor_id=1) 
  #
  # It returns json that looks like this:
  #
  # [
  #   {
  #     "user": {
  #       "id": 1,
  #       "first_name": "Test1",
  #       "last_name": "User1"
  #     }
  #   },
  #   {
  #     "user": {
  #       "id": 2,
  #       "first_name": "Test2",
  #       "last_name": "User2"
  #     }
  #   }
  # ]
  #
  def index
    return reject_unauthorized_request if @current_user.employee?

    if params[:vendor_id]
      contractors = User.where vendor_id: params[:vendor_id] 
    else
      contractors = User.where role: :employee
    end
    render json: contractors.to_json(only: [:first_name, :last_name, :id])
  end

  # POST /send-message
  # Function will first check if user is a client
  # If user is a client(AOI), then call the send method passing parameters
  # 
  # Input: vendor, body
  # Output: status ok if success
  #
  def send_message
    if @current_user.employee? 
      return render status: :unauthorized
    end

    #deliver_later: the controller action can continue without waiting for the send to complete
    #with: create params for action mailer to use
    UserMailer.with(vendor: params[:vendor], body: params[:body]).send.deliver_later

    render status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :password, :email, :role, :vendor_id)
  end
  
  def user_restricted_params
    params.require(:user).permit(:password)
  end

end