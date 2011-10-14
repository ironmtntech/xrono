@wip
Feature: Search Work Units
  In order to search work units
  User
  wants a nice search interface
  
  Scenario: Search for all work units containing a particular invoiced string
    Given I am an authenticated user with an admin role
    And a client "test client" exists with name: "test client", initials: "TTC"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket "test ticket" exists with project: project "test project", name: "test ticket"
    And a work_unit "test work unit" exists with ticket: ticket "test ticket", scheduled_at: "2010-01-01", hours: "1", invoiced: "123"
    And a work unit "test work unit2" exists with ticket: ticket "test ticket", scheduled_at: "2010-02-01", hours: "1", invoiced: "123"
    And I go to the work unit's page
    And I follow "123"
    Then I should see "2010-01-01" within "td"
    And I should see "2010-02-01" within "td"

  Scenario: Search for all work units containing a particular paid string
    Given I am an authenticated user with an admin role
    And a client "test client" exists with name: "test client", initials: "TTC"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket "test ticket" exists with project: project "test project", name: "test ticket"
    And a work_unit "test work unit" exists with ticket: ticket "test ticket", scheduled_at: "2010-03-01", hours: "1", paid: "12"
    And a work unit "test work unit2" exists with ticket: ticket "test ticket", scheduled_at: "2010-04-01", hours: "1", paid: "12"
    And a work unit "test work unit3" exists with ticket: ticket "test ticket", scheduled_at: "2010-01-01", hours: "1", paid: "34"
    And I go to the first work unit's page
    And I follow "12"
    Then I should see "2010-03-01" within "td"
    And I should see "2010-04-01" within "td"
    
  Scenario: Cannot search if I am not an admin
    Given I am an authenticated user with an developer role
    And I visit /work_units
    Then I should see "You must be an admin to do that"  
