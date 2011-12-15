require 'machinist/active_record'
require 'sham'
require 'faker'
include Faker

Sham.define do
  # User
  email                          { |index| index.to_s + Internet.email         }
  # Work Unit
  description(:unique => false)  { Lorem.paragraph                             }
  hours(:unique => false)        { BigDecimal("0.1")*rand(9) + rand(3)         }
  scheduled_at(:unique => false) { Date.current                                }
  hours_type(:unique => false)   { ["Normal", "Overtime", "CTO", "PTO"].sample }
  # Contact
  email_address                  { |index| "#{index}" + Internet.email         }
  first_name(:unique => false)   { Name.first_name                             }
  last_name(:unique => false)    { Name.last_name                              }
end

Contact.blueprint do
  first_name
  last_name
  email_address
  client { Client.make }
end

User.blueprint do
  email
  password                         { '123456'               }
  password_confirmation            { '123456'               }
  first_name                       { Name.first_name        }
  last_name(:unique => false)      { Name.last_name         }
  middle_initial(:unique => false) { ('A'..'Z').to_a.sample }
  daily_target_hours               { 8                      }
end

Client.blueprint do
  name     { [ Name.last_name, Name.last_name, Company.suffix ].join ' ' }
  initials { name.scan(/([A-Z])/).join.first(3)                          }
  status   { 'Active'                                                    }
end

Project.blueprint do
  name   { Internet.domain_name.humanize }
  client { Client.make                   }
end

Ticket.blueprint do
  project         { Project.make                        }
  name            { Lorem.words(2).join(' ').capitalize }
  description     { Lorem.sentence                      }
  estimated_hours { 2.0                                 }
end

WorkUnit.blueprint do
  # Note: The default is for unpaid and for uninvoiced
  ticket { Ticket.make }
  user   { User.make   }
  description
  hours
  scheduled_at
  hours_type
end

WorkUnit.blueprint(:paid) do
  paid { 'Check Number 1000' }
end

WorkUnit.blueprint(:invoiced) do
  invoiced { 'Invoice Number 1000' }
end

SiteSettings.blueprint do
  overtime_multiplier       { rand(3) + 1 }
  total_yearly_pto_per_user { 40          }
  client                    { Client.make }
end

Comment.blueprint do
  title            { Lorem.words(2).join(' ')            }
  comment          { Lorem.words(5).join(' ').capitalize }
  commentable_id   { Client.make.id                      }
  commentable_type { 'Client'                            }
  user_id          { User.make                           }
  active           { true                                }
end
