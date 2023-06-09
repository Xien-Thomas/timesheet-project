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

  # This is the basis of "View Contractors", this will view contractors UNDER the vendor in question
  # input is just be the vendor's info
  # output is just the contractor(s) under the given vendor
  def index
    # T - we're going to grab the vendor info from the url (ie that will be our params)

    # puts @current_user.inspect
    if @current_user.role.name == "Employee"
      return render status: :unauthorized
    end
    vendor = params[:vendor]

    contractors = User.where(vendor: vendor)

    render json: contractors.to_json, status: :ok
  end
end
