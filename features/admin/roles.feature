Feature: Roles

  Scenario: Edit a user's roles
    Given I am an authenticated user with an admin role
    And a project exists
    And a user exists
    When I am on the admin user's projects page
    And I press "Submit"
    Then I should see "Roles have been updated successfully" within "#flash_notice"

  @javascript
  Scenario: Admin clicks "[+/-]" to hide suspended clients 
    Given I am an authenticated user with an admin role
    And a client "test client" exists with name: "test client", initials: "TTC", status: "Suspended"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a user exists
    When I am on the admin user's projects page
    Then I should see "test project"
    And I follow "show_hide"
    Then "test project" should not be visible
