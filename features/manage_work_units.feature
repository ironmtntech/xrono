Feature: Manage Work Units
  In order to manage work units
  User
  wants a nice management interface

  @javascript
  Scenario: Register new work unit
    Given I am an authenticated user with an admin role
    And a client "test client" exists with name: "test client", initials: "TTC"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket "test ticket" exists with project: project "test project", name: "test ticket"
    And I visit /
    When I select "test client" from "work_unit_client_id"
    And I select "test project" from "work_unit_project_id"
    And I select "test ticket" from "work_unit_ticket_id"
    And I select "Overtime" from "hours_type"
    And I fill in "Hours" with "2"
    And I fill in "work_unit_description" with "test description"
    And I press "Create Work Unit"
    Then I should see "TTC: 3.0" within ".overtime"

  @javascript
  Scenario: Expand work unit description
    Given I am an authenticated user with an admin role
    And a client "test client" exists with name: "test client", initials: "TTC"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket "test ticket" exists with project: project "test project", name: "test ticket"
    And I visit /
    When I select "test client" from "work_unit_client_id"
    And I select "test project" from "work_unit_project_id"
    And I select "test ticket" from "work_unit_ticket_id"
    And I select "Overtime" from "hours_type"
    And I fill in "Hours" with "2"
    And I fill in "work_unit_description" with "test description"
    And I press "Create Work Unit"
    Then I should see "TTC: 3.0" within ".overtime"
    When I follow "[+/-]"
    Then I should see "test description"

  @javascript
  Scenario: Attempt to register a work unit on a suspended client
    Given I am an authenticated user with an admin role
    And a client "test client" exists with name: "test client", initials: "TTC", status: "Suspended"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket "test ticket" exists with project: project "test project", name: "test ticket"
    And I visit /
    When I select "test client" from "work_unit_client_id"
    And I select "test project" from "work_unit_project_id"
    And I select "test ticket" from "work_unit_ticket_id"
    And I select "Overtime" from "hours_type"
    And I fill in "Hours" with "2"
    And I fill in "work_unit_description" with "test description"
    And I press "Create Work Unit"
    Then I should see "This client is suspended. Please contact an Administrator."

  Scenario: Edit a work unit
    Given I am an authenticated user with an admin role
    And a client "test client" exists with name: "test client", initials: "TTC", status: "Suspended"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket "test ticket" exists with project: project "test project", name: "test ticket"
    And a work_unit exists with ticket: ticket "test ticket", description: "New description", hours: "1"
    When I go to the work unit's page
    And I follow "Edit Work Unit"
    And I fill in "Hours" with "2"
    And I press "Update Work unit"
    Then I should see "Work unit updated" within "#flash_notice"

  Scenario: Attempt to edit a work unit you do not have access to
    Given I am an authenticated user
    And a client "test client" exists with name: "test client", initials: "TTC", status: "Suspended"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket "test ticket" exists with project: project "test project", name: "test ticket"
    And a work_unit exists with ticket: ticket "test ticket", description: "New description", hours: "1"
    When I go to the work unit's page
    Then I should see "Access denied" within "#flash_notice"

  @javascript
  Scenario: Add new work order to a ticket
    Given I am an authenticated user with an admin role
    And a ticket "ticket1" exists
    When I am on the ticket's page
    And I follow "New Work Unit"
    And I select "Normal" from "work_unit_hours_type"
    And I fill in "Hours" with "2"
    And I fill in "Description" with "test description"
    When I press "Create Work unit"
    Then I should see "Work Unit created successfully" within "#flash_notice"

  @javascript
  Scenario: Attempt to register a work unit with CTO that's not an internal client
    Given I am an authenticated user with an dev role
    And a client "test client" exists with name: "test client", initials: "TTC", status: "Active"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket "test ticket" exists with project: project "test project", name: "test ticket"
    And I am assigned to the project
    And a client "test client2" exists with name: "test client2", initials: "TTD"
    And a site settings exists with client: client "test client2"
    And I visit /
    And I follow "close"
    When I select "test client" from "work_unit_client_id"
    And I select "test project" from "work_unit_project_id"
    And I select "test ticket" from "work_unit_ticket_id"
    And I select "CTO" from "hours_type"
    And I fill in "Hours" with "2"
    And I fill in "work_unit_description" with "test description"
    And I press "Create Work Unit"
    Then show me the page
    Then I should see "You can only select CTO as hours type on internal client."
