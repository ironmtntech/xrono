require 'spec_helper'

describe Contact do
  let(:contact) { Contact.make }
  let(:contact_2) { Contact.make }
  let(:contact_2_receives_email) { Contact.make(:receives_email => true) }
  let(:contact_3) { Contact.make }

  it { should belong_to :client }
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email_address }

  describe 'for_client' do
    it 'should return the proper list of contacts for the client' do
      client = contact_2.client
      Contact.for_client(client).include?(contact_2).should be_true
      Contact.for_client(client).include?(contact_3).should be_false
    end
  end

  describe 'receives_email' do
    it 'should return the proper list of contacts that can receive email' do
      client = contact_2_receives_email.client
      Contact.for_client(client).receives_email.include?(contact_2_receives_email).should be_true
      Contact.for_client(client).receives_email.include?(contact_3).should_not be_true
    end
  end
end
