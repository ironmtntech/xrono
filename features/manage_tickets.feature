Feature: Manage tickets
  In order to manage tickets
  Visitor
  wants a nice management interface

  Scenario: List tickets
    Given I am an authenticated user with an admin role
    Given a client "test client" exists
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket exists with project: project "test project", name: "test ticket"
    When I am on the ticket's page
    Then I should see "test ticket"

  Scenario: View a ticket
    Given I am an authenticated user with an admin role
    Given a client "test client" exists with name: "test client"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket exists with project: project "test project", name: "test ticket"
    When I am on the ticket's page
    Then I should see a link with text "Project: test project" within the breadcrumbs
    Then I should see a link with text "Client: test client" within the breadcrumbs
    Then I should see "Edit Ticket" within the subnav

  Scenario: Edit a ticket
    Given I am an authenticated user with an admin role
    Given a client "test client" exists
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket exists with project: project "test project", name: "test ticket"
    When I am on the ticket's edit page
    When I fill in "Name" with "test ticket2"
    And I press "Update"
    Then I should see "test ticket2"
  
  Scenario: Edit a ticket unsuccessfully
    Given I am an authenticated user with an admin role
    Given a client "test client" exists
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket exists with project: project "test project", name: "test ticket"
    When I am on the ticket's edit page
    When I fill in "Name" with ""
    When I fill in "Description" with ""
    And I press "Update"
    Then I should see "There was a problem creating the ticket"

  Scenario: Register new ticket
    Given I am an authenticated user with an admin role
    Given a client "test client" exists
    And a project exists with name: "test project", client: client "test client"
    And I am assigned to the project
    And I am on the project's page
    And I follow "New Ticket"
    When I fill in "Name" with "name 1"
    And I fill in "Estimated hours" with "3"
    And I press "Create"
    Then I should see "name 1"

  @wip
  Scenario: Register new ticket
    Given I am an authenticated user with an admin role
    And a client exists with name: "New client"
    And a project exists with client: client, name: "New project"
    When I visit /
    And I select "New client" from "ticket_client_id"
    And I select "New project" from "ticket_project_id"
    And I fill in "ticket_name" with "New ticket"
    And I fill in "ticket_description" with "New description"
    When I press "ticket_submit"
    Then I should see "Ticket created successfully" within ".alert-message"
    When I go to the project's page
    Then I should see "New ticket" within "table"

  Scenario: Client can add a ticket to an existing project
    Given I am an authenticated client on an existing project page
    Then I should be able to create a new ticket
