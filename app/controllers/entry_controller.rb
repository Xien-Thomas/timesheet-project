class EntryController < ApiBaseController

  def create
    # return reject_unauthorized_request unless @current_user.employee?

    # @entry = Entry.new entry_params

    # if @entry.save
    #   return render json: { message: 'Entry successfully created' }, status: :created
    # else
    #   return render json: { message: @entry.errors.full_messages.join(", ") }, status: :unprocessable_entity
    # end
  end

  def destroy

  end

  def update

  end

  def index

  end

  # private

  # def entry_params
  #   params.require(:entry).permit(
  #     :date, 
  #     :hours,
  #     :entry_type,
  #     :timesheet_id)
  # end
end
