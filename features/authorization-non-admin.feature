Feature: Non-admin Authorization
  As a non-admin user
  I should not have admin priveleges

  Scenario: List all users (non-admin)
    Given I am an authenticated user
    When I go to the admin users page
    Then I should be on the home page
    And I should see "You must be an admin to do that." within "#flash_error"

  Scenario: Create a new user (non-admin)
    Given I am an authenticated user
    When I go to the admin user's new page
    Then I should be on the home page
    And I should see "You must be an admin to do that." within "#flash_error"

  Scenario: Edit a user (non-admin)
    Given I am an authenticated user
    Given a user exists with first_name: "Test", last_name: "Man", middle_initial: "T", email: "test@example.com", password: "secret", password_confirmation: "secret"
    When I go to the admin user's edit page
    Then I should be on the home page
    And I should see "You must be an admin to do that." within "#flash_error"

