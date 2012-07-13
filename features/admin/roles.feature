Feature: Roles

  Scenario: Edit a user's roles
    Given I am an authenticated user with an admin role
    And a project exists
    And a user exists
    When I am on the admin user's projects page
    And I press "Submit"
    Then I should see "Roles have been updated successfully" within ".alert-message"
