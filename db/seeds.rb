# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user_role = Role.create!(name: "Employee")
manager_role = Role.create!(name: "Manager")
admin_role = Role.create!(name: "Admin")

type1 = Type.create!(name: "Hours Worked")
type2 = Type.create!(name: "Holiday Hours")
type3 = Type.create!(name: "Paid Time Off")

vendor1 = Vendor.create!(name: "revature")
vendor2 = Vendor.create!(name: "inferior vendor")

user1 = User.create!(first_name: "Test1", last_name: "User1", email: "test1@example.com", password: "password1", role: user_role, vendor: vendor1)
user2 = User.create!(first_name: "Test2", last_name: "User2", email: "test2@example.com", password: "password2", role: user_role, vendor: vendor2)
user3 = User.create!(first_name: "Test3", last_name: "Manager3", email: "test3@example.com", password: "password3", role: manager_role)
user4 = User.create!(first_name: "Test4", last_name: "Admin4", email: "test4@example.com", password: "password4", role: admin_role)

timesheet1 = Timesheet.create!(user: user1)
timesheet2 = Timesheet.create!(user: user2)

entry1 = Entry.create!(timesheet: timesheet1, date: Time.now, hours: 8, type: type1)
entry1 = Entry.create!(timesheet: timesheet1, date: Time.now, hours: 7.5, type: type1)



