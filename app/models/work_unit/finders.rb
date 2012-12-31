class WorkUnit < ActiveRecord::Base
  module Finders
    def hours_types
      ['Normal', 'Overtime', 'CTO', 'PTO']
    end

    def scheduled_between(start_time, end_time)
      where('scheduled_at BETWEEN ? AND ?', start_time, end_time)
    end

    def unpaid
      where(:paid => [nil, ''])
    end

    def not_invoiced
      where(:invoiced => [nil, ''])
    end

    def for_client(client)
      joins({:ticket => {:project => [:client]}}).where("clients.id = ?", client.id)
    end

    def except_client(client)
      joins({:ticket => {:project => [:client]}}).where("clients.id <> ?", client.id)
    end

    def for_project(project)
      joins({:ticket => [:project]}).where("projects.id = ?", project.id)
    end

    def for_ticket(ticket)
      where(:ticket_id => ticket.id)
    end

    def for_user(user)
      where(:user_id => user.id)
    end

    def for_users(users)
      where("user_id IN (?)", users.map{|user| user.id})
    end

    def sort_by_scheduled_at
      order('scheduled_at DESC')
    end

    def pto
      where(:hours_type => 'PTO')
    end

    def cto
      where(:hours_type => 'CTO')
    end

    def overtime
      where(:hours_type => 'Overtime')
    end

    def normal
      where(:hours_type => 'Normal')
    end

    def on_estimated_ticket
       joins(:ticket).where("tickets.estimated_hours IS NOT NULL AND tickets.estimated_hours > 0")
    end
  end
end
