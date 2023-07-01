class TimesheetController < ApplicationController
  include Authenticate

  #
  # This method is for Employees to view their Timesheets.
  #
  # It returns an array of objects with the following attributes:
  #   date: The date of the entry
  #   hours: The number of hours worked
  #   type: The type of the entry
  #
  def show
    unless @current_user.role["name"] == 'Employee'
      # TODO: redirect to the proper page for an Admin or Manager
      return render json: nil, status: :unauthorized
    end
    entries = Array.new
    Entry.all.where(timesheet: Timesheet.where(user: @current_user).first).each do |entry|
      entries.push({"date" => entry.date, "hours" => entry.hours.to_f, "type" => Type.where(id: entry.type_id).first.name})
    end
    render json: entries, status: :ok
  end
end
