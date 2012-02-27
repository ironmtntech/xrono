Feature: Project Assignment
  In order to manage projects properly
  Administrators should be able to assign projects to developers

  @wip
  Scenario: Assign a project to a developer
    Given I am an authenticated user with an admin role
    And a user exists with a "developer" role
    And a client "Acme" exists
    And a project exists with name: "Testproject", client: client "Acme"
    When I assign the project to the user
    Then the user should have access to the project

  Scenario: User tries to access a project they are not assigned to
    Given I am an authenticated user
    And a client "Acme" exists
    And a project exists with name: "Testproject", client: client "Acme"
    When I go to the project's page
    Then I should see "Access denied." within ".alert-message"

  Scenario: User tries to access a project they are assigned to
    Given I am an authenticated user
    And a client "Acme" exists
    And a project exists with name: "Testproject", client: client "Acme"
    And I am assigned to the project
    When I go to the project's page
    Then I should see "Testproject" within the breadcrumbs

  Scenario: User tries to access the client of a project they are not assigned to
    Given I am an authenticated user
    And a client "Acme" exists
    And a project exists with name: "Testproject", client: client "Acme"
    When I go to the client's page
    Then I should see "Access denied." within ".alert-message"

  Scenario: User tries to access a ticket of a project they are not assigned to
    Given I am an authenticated user
    And a client "Acme" exists
    And a project "Testproject" exists with name: "Testproject", client: client "Acme"
    And a ticket exists with project: project "Testproject", name: "test ticket"
    When I go to the ticket's page
    Then I should see "Access denied." within ".alert-message"

  Scenario: User tries to access a work unit of a project they are not assigned to
    Given I am an authenticated user
    And a client "Acme" exists
    And a project "Testproject" exists with name: "Testproject", client: client "Acme"
    And a ticket "test ticket" exists with project: project "Testproject", name: "test ticket"
    And a work_unit exists with ticket: ticket "test ticket", hours: "1", scheduled_at: "2010-10-01"
    When I go to the work_unit's page
    Then I should see "Access denied." within ".alert-message"

  Scenario: User tries to select a client they don't have access to on the dashboard
    Given I am an authenticated user
    And a client "test client" exists with name: "test client", initials: "TTC"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket "test ticket" exists with project: project "test project", name: "test ticket"
    When I visit /
    Then I should not see "test client"

  Scenario: User shouldn't see projects they aren't assigned to on the client show page
    Given I am an authenticated user
    And a client "test client" exists with name: "test client", initials: "TTC"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a project "assigned project" exists with name: "assigned project", client: client "test client"
    And I am assigned to the project
    When I go to the client's page
    Then I should not see "test project"
    And I should see "assigned project"
