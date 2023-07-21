require "test_helper"
require_relative '../set_up_test.rb'

class TimesheetControllerTest < ActionDispatch::IntegrationTest
  extend SetUpTest
  set_up_test
  
  test "timesheet#show should respond with a timesheet object" do
    get "/timesheet/#{@user1.timesheet.id}", headers: { 'Authorization' => @user1_token }
    assert_response :ok
    timesheet = JSON.parse(response.body)['timesheet']
    assert timesheet
    assert timesheet['user_id']
    assert timesheet['id']
    entry = timesheet['entries_attributes'].first
    assert entry['hours']
    assert entry['entry_type']
    assert entry['date']
  end  
  test "timesheet#show should not allow employees to view other employees' timesheets" do
    get "/timesheet/#{@user2.timesheet.id}", headers: { 'Authorization' => @user1_token }
    assert_response :unauthorized
  end
  test "timesheet#index should include array of timesheet objects with id, user_id, and entries_attributes with dates, hours and types" do
    get "/timesheet", headers: { 'Authorization' => @manager_token }
    assert_response :ok
    timesheets = JSON.parse(response.body)
    timesheet = timesheets.first['timesheet']
    assert timesheet['user_id']
    assert timesheet['id']
    entry = timesheet['entries_attributes'].first
    assert entry['hours']
    assert entry['entry_type']
    assert entry['date']
  end
  test "timesheet#index should not allow employees to view all timesheets" do
    get '/timesheet', headers: { 'Authorization' => @user1_token }
    assert_response :unauthorized
  end
  test "timesheet#update should allow an employee to add and edit entries" do
    patch "/timesheet/#{@user1.timesheet.id}", headers: { 'Authorization' => @user1_token },
      params: { 
        timesheet: {
          entries_attributes: [
              {
                id: @entry1.id,
                date: "9-4-2023",
                hours: 8
              }, 
              {
                id: @entry3.id,
                date: "7-4-2023",
                hours: 8
              },
              {
                date: "10-4-2023",
                hours: 2,
                entry_type: "pto"
              }, 
              {
                date: "11-4-2023",
                hours: 3
              }
            ]
          }
        },
      as: :json
    assert_response :created
    entries = Entry.where(timesheet_id: @user1.timesheet.id)
    assert entries.length == 4
    assert entries[0][:hours] == 8
    assert entries[1][:hours] == 8
    assert entries[2][:entry_type] == 'pto'
    assert entries[3][:hours] == 3
    assert entries[3][:entry_type] == 'standard'
    assert entries[3][:status] == 'pending'
  end  
  test "timesheet#update should allow a manager to approve/deny entries" do
    patch "/timesheet/#{@user1.timesheet.id}", headers: { 'Authorization' => @manager_token },
      params: { 
        timesheet: {
          entries_attributes: [
              {
                id: @entry1.id,
                status: 'approved'
              }, 
              {
                id: @entry3.id,
                status: 'rejected'
              }
            ]
          }
        },
      as: :json
    assert_response :created
    entries = Entry.where(timesheet_id: @user1.timesheet.id)
    assert entries.length == 2
    assert entries[0][:status] == 'approved'
    assert entries[1][:status] == 'rejected'
  end  
end
