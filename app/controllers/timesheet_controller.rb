class TimesheetController < ApiBaseController
  #
  # This method is for Employees to view their Timesheets.
  #
  # It returns json that looks like this:
  #
  # {
  #   "timesheet": {
  #     "id": 21,
  #     "user_id": 1,
  #     "entries_attributes": [
  #       {
  #         "id": 1,
  #         "date": "2023-07-20",
  #         "hours": "8.0",
  #         "entry_type": "standard",
  #         "status": "approved"
  #       },
  #       {
  #         "id": 2,
  #         "date": "2023-07-20",
  #         "hours": "7.5",
  #         "entry_type": "standard",
  #         "status": "approved"
  #       }
  #     ]
  #   }
  # }
  #
  def show
    return reject_unauthorized_request if @current_user.employee? && (@current_user.timesheet.id != params[:id].to_i)
    timesheet = Hash.new
    timesheet[:timesheet] = Timesheet.select(:id, :user_id).find(params[:id]).attributes
    timesheet[:timesheet][:entries_attributes] = 
      Entry
        .select(:id, :date, :hours, :entry_type, :status)
        .where(timesheet_id: params[:id])
        .map {|e| e.attributes}

    return render json: timesheet.to_json, status: :ok
  end

  def create

  end

  def destroy

  end

  #
  # This method is for making changes to a Timesheet.
  #
  # Employees can edit date, hours, and entry_type, but only managers/admins can edit status.
  # Entries cannot be updated after being approved or rejected
  #
  # It expects json that looks like this:
  #
  # {
  #   "timesheet": {
  #     "entries_attributes": [  
  #       {                       # include id to edit an existing entry
  #         "id": 1, 
  #         "date": "2023-07-20",
  #         "hours": "8.0",
  #         "entry_type": "standard"
  #       },
  #       {                       # omit id to create a new one!
  #         "date": "2023-07-20",
  #         "hours": "7.5",
  #         "entry_type": "standard"
  #       }
  #     ]
  #   }
  # }
  #
  def update
    @timesheet = Timesheet.find(params[:id])
    if @timesheet.update(timesheet_update_params)
      return render json: { message: 'Entries successfully updated/created' }, status: :created
    else
      return render json: { message: @timesheet.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  #
  # This method is for Managers/Admins to view all Timesheets.
  #
  # It returns json that looks like this:
  #
  # [
  #   {
  #     "timesheet": {
  #       "id": 21,
  #       "user_id": 1,
  #       "entries_attributes": [
  #         {
  #           "id": 1,
  #           "date": "2023-07-20",
  #           "hours": "8.0",
  #           "entry_type": "standard",
  #           "status": "approved"
  #         },
  #         {
  #           "id": 2,
  #           "date": "2023-07-20",
  #           "hours": "7.5",
  #           "entry_type": "standard",
  #           "status": "approved"
  #         }
  #       ]
  #     }
  #   },
  #   {
  #     "timesheet": {
  #       "id": 22,
  #       "user_id": 2,
  #       "entries_attributes": [
  #       ]
  #     }
  #   }
  # ]
  #
  def index
    return reject_unauthorized_request if @current_user.employee?

    timesheets = Timesheet.select(:id, :user_id).all.map { |t| { timesheet: { id: t.id, user_id: t.user_id, entries_attributes: [] } } }
    entries = Entry.select(:id, :date, :hours, :entry_type, :status).all
    timesheets.each { |t| t[:timesheet][:entries_attributes] = entries.where(timesheet_id: t[:timesheet][:id]).map {|e| e.attributes} }
      
    render json: timesheets.to_json, status: :ok
  end

  private

  def timesheet_update_params
    if @current_user.employee?
      params.require(:timesheet).permit(
        entries_attributes: [:id, :date, :time, :hours, :entry_type])
    elsif @current_user.manager?
      params.require(:timesheet).permit(
        entries_attributes: [:id, :status])
    else
      params.require(:timesheet).permit(
        entries_attributes: [:id, :date, :time, :hours, :entry_type, :status])
    end
  end

  def timesheet_create_params
    params.require(:timesheet).permit(
      :entries_attributes,
      :user_id)
  end

  def entry_search_params
    params.require(:entry).permit(
      :timesheet_id)
  end
end