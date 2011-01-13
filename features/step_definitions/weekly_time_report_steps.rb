Given /^(\d+) work units exist for that user$/ do |number|
  user = User.last
  client = Client.create!(name: "Regis", status: "Good")
  project = Project.create!(name: "Haircutting", client_id: client.id)
  ticket = Ticket.create!(name: "Cut Hairs", project_id: project.id, description: "Do the cutting of the hairs.")
  number.to_i.times { WorkUnit.create!(description: "Did the clipping and the cutting", ticket_id: ticket.id, hours: 8, scheduled_at: "2010-10-01 12:00:00", user_id: user.id) }
end
