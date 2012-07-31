Feature: Client Management
  As a user
  I should be able to manage clients

  Scenario: List clients as non admin
    Given I am an authenticated user
    And a client "client1" exists with name: "client1"
    And a client "client2" exists with name: "client2"
    And a project "project1" exists with client: client "client1"
    And a project "project2" exists with client: client "client2"
    And I am assigned to the project
    When I go to the clients page
    Then I should see "client2" within ".clients"
    And I should not see a link with text "New Client"

  Scenario: List clients as non admin
    Given I am an authenticated user with an admin role
    Given the following clients:
      |name|status|
      |name 1|Active|
      |name 2|Active|
      |name 3|Active|
      |name 4|Active|
    When I go to the clients page
    Then I should see the following clients:
      |Name  |Initials       |Hours|Uninvoiced|Status|Recent Users|Edit|
      |name 1|               |0.0    |0.0         |Active|            |Edit|
      |name 2|               |0.0    |0.0         |Active|            |Edit|
      |name 3|               |0.0    |0.0        |Active|            |Edit|
      |name 4|               |0.0    |0.0         |Active|            |Edit|
    And I should see a link with text "New Client"

  Scenario: View a client as a non admin
    Given I am an authenticated user
    And a client "test client" exists
    And a project "test project" exists with client: client "test client", name: "test project"
    And I am assigned to the project
    When I am on the client's page
    Then I should see "Projects"
    And I should not see a link with text "Edit" within "#client_details"

  Scenario: View a client as an admin
    Given I am an authenticated user with an admin role
    And a client "test client" exists
    When I am on the client's page
    Then I should see "Projects"
    And I should see a link with text "Edit"

  Scenario: View inactive clients as a non admin
    Given I am an authenticated user
     When I am on the inactive clients page
     Then I should see "Access denied."

  Scenario: View inactive clients as a non admin
    Given I am an authenticated user with an admin role
     When I am on the inactive clients page
     Then I should see "All Inactive Clients"

  Scenario: View suspended clients as a non admin
    Given I am an authenticated user
     When I am on the suspended clients page
     Then I should see "Access denied."

  Scenario: View suspended clients as a non admin
    Given I am an authenticated user with an admin role
     When I am on the suspended clients page
     Then I should see "All Suspended Clients"

  Scenario: Edit a client
    Given I am an authenticated user with an admin role
    And a client "test client2" exists with name: "test client2", initials: "TC2", status: "Active"
    When I am on the client's edit page
    Then the "client_name" field under "body" should contain "test client2"
    And the "client_initials" field under "body" should contain "TC2"
    And the "client_status" field under "body" should contain "Active"
    And I select "Inactive" from "Status"
    And I press "Update Client"
    And I should see "test client2"
    And I should see "Inactive"

  Scenario: Edit a client - invalid
    Given I am an authenticated user with an admin role
    And a client "test client2" exists with name: "test client2", initials: "TC2", status: "Active"
    When I am on the client's edit page
    Then the "client_name" field under "body" should contain "test client2"
    And the "client_initials" field under "body" should contain "TC2"
    And the "client_status" field under "body" should contain "Active"
    And I select "Inactive" from "Status"
    And I fill in "Name" with ""
    And I press "Update Client"
    Then I should see "There was a problem saving the client."

  Scenario: Register new client as a non admin
    Given I am an authenticated user
    And I am on the new client page
    Then I should see "Access denied."

  Scenario: Register new client as an admin
    Given I am an authenticated user with an admin role
    And I am on the new client page
    When I fill in "Name" with "name 1"
    And I select "Active" from "Status"
    And I press "Create"
    Then I should see "name 1"

  Scenario: Register new client as an admin - invalid
    Given I am an authenticated user with an admin role
    And I am on the new client page
    And I press "Create"
    Then I should see "There was a problem saving the new client."

  Scenario: Register new client - the form
    Given I am an authenticated user with an admin role
    When I go to the new client page
    Then I should see a link with text "Cancel" within the actions list

