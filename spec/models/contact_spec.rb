require 'spec_helper'

describe Contact do
  before { @contact = Contact.make }

  it { should belong_to :client }
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email_address }

  describe 'for_client' do
    it 'should return the proper list of contacts for the client' do
      contact_1 = Contact.make
      client = contact_1.client
      contact_2 = Contact.make
      Contact.for_client(client).include?(contact_1).should be_true
      Contact.for_client(client).include?(contact_2).should be_false
    end
  end

  describe 'receives_email' do
    it 'should return the proper list of contacts that can receive email' do
      contact_1 = Contact.make(:receives_email => true)
      client = contact_1.client
      contact_2 = Contact.make
      Contact.for_client(client).receives_email.include?(contact_1).should be_true
      Contact.for_client(client).receives_email.include?(contact_2).should_not be_true
    end
  end
end
