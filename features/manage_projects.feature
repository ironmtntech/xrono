Feature: Manage projects
  In order to manage projects
  Visitor
  wants a nice management interface

  Scenario: List projects
    Given I am an authenticated user
    Given a client "test client" exists
    And a project exists with name: "test project", client: client "test client"
    And I am assigned to the project
    When I am on the client's page
    Then I should see "test project"

  Scenario: View a project
    Given I am an authenticated user
    Given a client "test client" exists with name: "test client"
    And a project exists with name: "test project", client: client "test client"
    And I am assigned to the project
    When I am on the client's page
    And I follow "test project"
    Then I should see a link with text "Back to client: test client"
    Then I should see a link with text "Edit"

  Scenario: Edit a project
    Given I am an authenticated user with an admin role
    Given a client "test client2" exists
    And a project exists with name: "test project", client: client "test client2"
    When I am on the client's page
    And I follow "test project"
    And I follow "Edit"
    And I fill in "Name" with "project 2"
    And I press "Update"
    Then I should see "project 2"

  Scenario: Edit a project - invalid
    Given I am an authenticated user with an admin role
    Given a client "test client2" exists
    And a project exists with name: "test project", client: client "test client2"
    And I am assigned to the project
    When I am on the client's page
    And I follow "test project"
    And I follow "Edit"
    And I fill in "Name" with ""
    And I press "Update"
    Then I should see "There was a problem saving the project."

  Scenario: Register new project
    Given I am an authenticated user with an admin role
    Given a client "test client" exists
    Given I am on the client's page
    And I follow "New Project"
    When I fill in "Name" with "name 1"
    Then I should see a link with text "Cancel" within ".actions"
    And I press "Create"
    Then I should see "name 1"

  Scenario: Register new project - invalid
    Given I am an authenticated user with an admin role
    Given a client "test client" exists
    Given I am on the client's page
    And I follow "New Project"
    When I fill in "Name" with ""
    Then I should see a link with text "Cancel" within ".actions"
    And I press "Create"
    Then I should see "There was a problem saving the new project."
