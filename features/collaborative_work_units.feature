Feature: Ticket board
  In order to add work units for clients/projects not currently assigned
  Developer
  wants a checkbox to populate client selector with all clients

  @javascript
  Scenario: Collaboration checkbox is displayed for developers
    Given I am an authenticated user with a developer role
    And I visit /
    And I follow "close"
    Then I should see "Show hidden clients and projects"

  Scenario: Collaboration checkbox is not displayed for clients
    Given I am an authenticated user with a client role
    And I visit /
    Then I should not see "Show hidden clients and projects"
    

  Scenario: Only show clients with projects assigned to current users by default
    Given I am an authenticated user with a developer role
    Given a client "test client" exists with name: "test client"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket exists with project: project "test project", name: "test ticket"
    And I am assigned to the project

    And a client "test client1" exists with name: "test client1", initials: "TC1", status: "Active"
    And a project exists with name: "test project1", client: client "test client1"
    And I am assigned to the project

    And a client "test client2" exists with name: "test client2", initials: "TC2", status: "Active"
    And a project exists with name: "test project2", client: client "test client2"
    And I visit /
    Then I should not see "test client2" within "#work_unit_client_id"
    Then I should see "test client1" within "#work_unit_client_id"

    @javascript
  Scenario: Clicking checkbox reveals all clients 
    Given I am an authenticated user with a developer role
    Given a client "test client" exists with name: "test client"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket exists with project: project "test project", name: "test ticket"
    And I am assigned to the project

    And a client "test client1" exists with name: "test client1", initials: "TC1", status: "Active"
    And a project exists with name: "test project1", client: client "test client1"
    And I am assigned to the project

    And a client "test client2" exists with name: "test client2", initials: "TC2", status: "Active"
    And a project exists with name: "test project2", client: client "test client2"
    And I visit /
    And I follow "close"
    And I check "checkbox"
    Then I should see "test client1" within "#work_unit_client_id"
    Then I should see "test client2" within "#work_unit_client_id"

    
    @javascript
  Scenario: When box is checked one can also see projects not assigned to oneself
    Given I am an authenticated user with a developer role
    Given a client "test client" exists with name: "test client"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket exists with project: project "test project", name: "test ticket"
    And I am assigned to the project

    And a client "test client1" exists with name: "test client1", initials: "TC1", status: "Active"
    And a project exists with name: "test project1", client: client "test client1"
    And I am assigned to the project

    And a client "test client2" exists with name: "test client2", initials: "TC2", status: "Active"
    And a project exists with name: "test project2", client: client "test client2"
    And I visit /
    And I follow "close"
    And I check "checkbox"
    And I select "test client2" from "work_unit_client_id"
    Then I should see "test project2" within "#work_unit_project_id"


    @javascript
  Scenario: Checking & unchecking box re-hides clients without assigned projects
    Given I am an authenticated user with a developer role
    Given a client "test client" exists with name: "test client"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket exists with project: project "test project", name: "test ticket"
    And I am assigned to the project

    And a client "test client1" exists with name: "test client1", initials: "TC1", status: "Active"
    And a project exists with name: "test project1", client: client "test client1"
    And I am assigned to the project

    And a client "test client2" exists with name: "test client2", initials: "TC2", status: "Active"
    And a project exists with name: "test project2", client: client "test client2"
    And I visit /
    And I follow "close"
    And I check "checkbox"
    And I select "test client2" from "work_unit_client_id"
    And I uncheck "checkbox"
    Then I should not see "test client2" within "#work_unit_client_id"
    
  @javascript
  Scenario: Add new work order to a ticket
    Given I am an authenticated user with a developer role
    Given a client "test client" exists with name: "test client"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket exists with project: project "test project", name: "test ticket"
    And I visit /
    And I follow "close"
    And I check "checkbox"
    And I select "test client" from "work_unit_client_id"
    And I select "test project" from "work_unit_project_id"
    And I select "test ticket" from "work_unit_ticket_id"
    And I select "Normal" from "hours_type"
    And I fill in "work_unit_hours" with "2"
    And I fill in "work_unit_description" with "test description"
    When I press "Create Work Unit"
    Then I should see "Current: 2.0" within "#current_hours"
