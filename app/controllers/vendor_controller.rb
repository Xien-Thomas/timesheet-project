class VendorController < ApiBaseController
  # This method adds a new vendor.
  # Only admins are authorized to use this method.
  #
  # It expects json that looks like this:
  #
  # {
  #   "vendor": {
  #     "name": "new vendor"
  #   }
  # }
  def create
    return reject_unauthorized_request unless @current_user.admin?

    vendor = Vendor.new(vendor_params)
    if vendor.save
      return render json: { message: "Vendor successfully created."}, status: :created
    else 
      return render json: { message: vendor.errors.full_messages.join(', ')}, status: :unprocessable_entity
    end
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name)
  end
end
