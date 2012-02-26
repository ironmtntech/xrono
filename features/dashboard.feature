Feature: Dashboard

  Scenario: Total hours for each day
    Given I am on the clients page
    Given I am an authenticated user
    And I have a "Normal" work unit scheduled today for "3.0" hours
    And I have an "Overtime" work unit scheduled today for "2.0" hours
    When I go to the home page
    Then I should see "Week: 6.0" within ".calendar_foot"
    Then I should see "Current: 6.0" within "#current_hours"

 Scenario: Non-entered time warning
    Given I am an authenticated user with a developer role
    And I have no work units for the previous day
    When I go to the home page
    Then I should see "You have not entered any time for the previous working day." within "#message"
  
  @javascript @test
  Scenario: Only show projects assigned to current users on Dashboard
    Given I am an authenticated user with a developer role
    Given a client "test client" exists with name: "test client"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket exists with project: project "test project", name: "test ticket"
    And I am assigned to the project
    And a project exists with name: "test project1", client: client "test client"
    And I am assigned to the project
    And a project exists with name: "test project2", client: client "test client"
    And I visit /
    And I follow "close"
    And I select "test client" from "work_unit[client_id]"
    Then I should see "test project1" within "#work_unit_project_id"
    Then I should not see "test project2" within "#work_unit_project_id"

  @javascript
  Scenario: It should show the new ticket field when I select new ticket while creating a work unit
    Given I am an authenticated user with a developer role
    Given a client "test client" exists with name: "test client"
    And a project "test project" exists with name: "test project", client: client "test client"
    And I am assigned to the project
    And I visit /
    And I follow "close"
    And I select "test client" from "work_unit[client_id]"
    And I select "test project" from "work_unit[project_id]"
    And I select "New Ticket" from "work_unit[ticket_id]"
    Then I should see the new ticket fields

  @javascript
  Scenario: It should create a new ticket on demand while making a work unit
    Given I am an authenticated user with a developer role
    Given a client "test client" exists with name: "test client", initials: "TTC", status: "Active"
    And a project "test project" exists with name: "test project", client: client "test client"
    And I am assigned to the project
    And I visit /
    And I follow "close"
    And I select "test client" from "work_unit[client_id]"
    And I select "test project" from "work_unit[project_id]"
    And I select "New Ticket" from "work_unit[ticket_id]"
    And I fill in "on_demand_ticket_name" with "test ticket"
    And I fill in "on_demand_ticket_description" with "test ticket"
    And I fill in "on_demand_ticket_estimated_hours" with "test ticket"
    And I select "Normal" from "Type:"
    And I fill in "work_unit_hours" with "2"
    And I fill in "work_unit_description" with "work_unit_description"
    And I press "Create Work Unit"
    Then there should be a ticket named "test ticket" with 2 hours


  @javascript
  Scenario: Only show tickets assigned to current users on Dashboard
    Given I am an authenticated user with a developer role
    Given a client "test client" exists with name: "test client"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket exists with project: project "test project", name: "test ticket"
    And I am assigned to the project
