# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

vendor1 = Vendor.create!(name: "revature")
vendor2 = Vendor.create!(name: "inferior vendor")

user1 = User.create!(first_name: "Test1", last_name: "User1", email: "test1@example.com", password: "password1", role: 0, vendor: vendor1)
user2 = User.create!(first_name: "Test2", last_name: "User2", email: "test2@example.com", password: "password2", role: 0, vendor: vendor2)
user3 = User.create!(first_name: "Test3", last_name: "Manager3", email: "test3@example.com", password: "password3", role: 1)
user4 = User.create!(first_name: "Test4", last_name: "Admin4", email: "test4@example.com", password: "password4", role: 2)

timesheet1 = Timesheet.create!(user: user1)
timesheet2 = Timesheet.create!(user: user2)

entry1 = Entry.create!(timesheet: timesheet1, date: Time.now, hours: 8, entry_type: 0, status: 2)
entry2 = Entry.create!(timesheet: timesheet1, date: Time.now, hours: 7.5, entry_type: 0)
entry3 = Entry.create!(timesheet: timesheet2, date: Time.now, hours: 6, entry_type: 1, status: 1)
entry4 = Entry.create!(timesheet: timesheet2, date: Time.now, hours: 3, entry_type: 2)



