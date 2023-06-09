class UserController < ApplicationController
  def create
  end

  def update
  end

  def destroy
  end

  def show
  end

  # this is the basis of "View Contractors", this will view contractors UNDER the vendor in question
  # input is just be the vendor's info
  # output is just the contractor(s) under the given vendor
  def index
    # T - we're going to grab the vendor info from the url (ie that will be our params)
    params = @requests.params
    vendor = params[:vendor]

    contractors = User.where("vendor = ?", vendor)

    return json: contractors.to_json
  end
end
