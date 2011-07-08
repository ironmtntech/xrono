Feature: Send Email to Client after Work Unit Creation

  Scenario: A client receives an email after work unit creation
    Given all emails have been delivered
    And a client "test client" exists
    And a contact "test contact" exists with client: client "test client", email_address: "testcontact@example.com", receives_email: true
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket "test ticket" exists with project: project "test project", name: "test ticket"
    When I create a work unit with ticket "test ticket"
    Then 1 email should be delivered bcc to "testcontact@example.com"
    And the first email should contain "For your records, a new work unit has been created:"
