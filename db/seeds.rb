# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

unless Rails.env.production?

  require File.expand_path(File.dirname(__FILE__) + "../../spec/blueprints")

  def it_is_foretold
    [true,false].rand
  end

  # Clients #

  4.times { Client.make }
  Client.make status: 'Suspended'


  # Projects #

  Client.all.each do |client|
    4.times { Project.make client: client }
  end


  # Tickets #

  Project.all.each do |project|
    4.times { Ticket.make project: project }
  end


  # Users #

  admin_user     = User.make :email => 'admin@xrono.org'
  developer_user = User.make :email => 'dev@xrono.org'
  locked_user    = User.make :email => 'locked@xrono.org'
  client_user    = User.make :email => 'client@xrono.org'

  developers = [ admin_user, developer_user ]
  8.times { developers.push User.make }

  # Roles #

  admin_user.has_role!(:admin)

  locked_user.lock_access!

  Project.all.each do |project|
    developers.each { |developer| developer.has_role!(:developer, project) if it_is_foretold }
    client_user.has_role!(:client, project) if it_is_foretold
  end


  # Work Units #

  monday = Date.current.monday
  friday = monday + 4
  two_weeks_ago = monday.advance(weeks: -1)
  four_weeks_ago = two_weeks_ago.advance(weeks: -2)

  (four_weeks_ago..friday).each do |date|
    developers.each do |user|
      tickets = Ticket.for_user user

      unless tickets.empty? or date.saturday? or date.sunday? or date == friday
        4.times { WorkUnit.make user: user,
                                ticket: tickets.rand,
                                scheduled_at: date.to_s,
                                hours_type: 'Normal' }
      end
    end
  end

  WorkUnit.scheduled_between(four_weeks_ago, two_weeks_ago).each do |work_unit|
    work_unit.update_attributes paid: "0987",
                                paid_at: Date.current.to_time,
                                invoiced: "6543",
                                invoiced_at: Date.current.to_time
  end

  developers.each do |user|
    tickets = Ticket.for_user user
    unless tickets.empty?
      WorkUnit.make user: user, ticket: tickets.rand, scheduled_at: monday.end_of_week.to_time, hours_type: 'Overtime', hours: 4
      WorkUnit.make user: user, ticket: tickets.rand, scheduled_at: friday.to_time, hours_type: 'CTO', hours: 8
    end
    user.work_units.scheduled_between(monday,monday+2).sample.update_attribute(:hours_type,'PTO')
  end



  # Comments #

  Client.all.each do |client|
    4.times { Comment.make user_id: developers.rand.id, commentable_id: client.id }
  end


  # Finally, an inactive client
  Client.make status: 'Inactive'

  # Create a site settings instance, set it to the first Client
  SiteSettings.make client: Client.first

end
