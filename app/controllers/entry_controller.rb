class EntryController < ApiBaseController

  def destroy
    return reject_unauthorized_request if @current_user.employee?

    entry_to_destroy = Entry.find params[:id]
    if entry_to_destroy.destroy
      return render json: { message: "Entry successfully deleted."}, status: :ok
    else
      return render json: { message: entry_to_destroy.errors.full_messages.join(', ') }, status: 500 
    end
  end
end
