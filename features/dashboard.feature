Feature: Dashboard

  Scenario: Total hours for each day
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
  
    @javascript
  Scenario: Only show projects assigned to current users on Dashboard
    Given I am an authenticated user with a developer role
    And a client "test client2" exists with name: "test client2", initials: "TC2", status: "Active"
    And a project exists with name: "test project1", client: client "test client2"
    And I am assigned to the project
    And a project exists with name: "test project2", client: client "test client2"
    When I am on the dashboard page
    And I select "test client2" from "Client"
    Then I should see "test project1" within "option"
    Then I should not see "test project2" within "option"

    @javascript
  Scenario: Only show tickets assigned to current users on Dashboard
    Given I am an authenticated user with a developer role
    Given a client "test client" exists with name: "test client"
    Given a project "test project" exists with name: "test project", client: client "test client"
    And I am assigned to the project
    Given a ticket exists with name: "test ticket", project: project "test project"
    When I am on the dashboard page
    And I select "test client" from "work_unit_client_id"
    And I select "test project" from "work_unit_project_id"
    Then I should see "test ticket" within "option"



