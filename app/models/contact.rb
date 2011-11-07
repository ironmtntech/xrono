class Contact < ActiveRecord::Base
  belongs_to :client

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email_address

  scope :for_client, lambda{ |client| where(:client_id => client.id)}
  scope :receives_email, where(:receives_email => true)
end
