Feature: Search Work Units
  In order to manage work units
  User
  wants a nice search interface
  
  Scenario: Search for all work units containing a particular invoice
    Given I am an authenticated user with an admin role
    And a client "test client" exists with name: "test client", initials: "TTC"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket "test ticket" exists with project: project "test project", name: "test ticket"
    And a work_unit "test work unit" exists with ticket: ticket "test ticket", scheduled_at: "2010-01-01", hours: "1", invoiced: "123"
    And a work unit "test work unit2" exists with ticket: ticket "test ticket", scheduled_at: "2010-01-01", hours: "1", invoiced: "123"
    And I go to the work unit's page
    And I follow "123"
    Then I should see "test work unit"
    And I should see "test work unit2"
                     
                     
