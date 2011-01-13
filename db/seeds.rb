# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

require File.expand_path(File.dirname(__FILE__) + "../../spec/blueprints")

# Create 4 clients and 4 users with client role
print "Creating clients..."
4.times do
  client = Client.make
  2.times { Project.make(:client => client) }
  User.make.has_role!(:client, client.projects.first)
end
puts "done"

# Create several developer accounts
print "Creating users..."
User.make(:email => 'admin@xrono.org', :password => '123456', :password_confirmation => '123456').has_role!(:admin)
User.make(:email => 'dev@xrono.org', :password => '123456', :password_confirmation => '123456').has_role!(:developer, Project.all.shuffle.first)
User.find_by_email('dev@xrono.org').has_role!(:developer, Project.all.shuffle.first)
User.make(:email => 'locked@xrono.org', :password => '123456', :password_confirmation => '123456')
User.make(:email => 'client@xrono.org', :password => '123456', :password_confirmation => '123456').has_role!(:client, Project.all.shuffle.first)
8.times { User.make.has_role!(:developer, Project.all[rand(Project.all.count)]) }
puts "done"

# Create 2 tickets per project
print "Creating tickets..."
Project.all.each do |project|
  2.times { Ticket.make(:project => project) }
end
puts "done"

# Create a bunch of work units
print "Creating work units..."

User.all.each do |user|
  20.times { WorkUnit.make(:ticket => Ticket.for_user(user).shuffle.first,
                           :user => user,
                           :scheduled_at => Date.current.beginning_of_week + (-6..6).to_a.shuffle.first.days ) } unless Ticket.for_user(user).empty?
end

puts "done"

# Create 2 contacts per client
Client.all.each do |client|
  2.times { Contact.make(:client => client) }
end

# Set one client inactive, one suspended
Client.all[rand(4)].update_attribute(:status, "Suspended")
Client.all[rand(4)].update_attribute(:status, "Inactive")

# Lock a user
User.find_by_email('locked@xrono.org').lock_access!
