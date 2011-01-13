Feature: Manage users (admin)

  Scenario: Lock a user
    Given I am an authenticated user with an admin role
    And a user exists with first_name: "Test", last_name: "Man", middle_initial: "T", email: "test@example.com", password: "secret", password_confirmation: "secret"
    When I go to the admin user's edit page
    And I check "user_locked"
    And I press "Update"
    Then I should see "Updated successfully"

  Scenario: Unlock a user
    Given I am an authenticated user with an admin role
    And a user exists with first_name: "Test", last_name: "Man", middle_initial: "T", email: "test@example.com", password: "secret", password_confirmation: "secret", locked_at: "2010-01-01"
    When I go to the admin user's edit page
    And I uncheck "user_locked"
    And I press "Update"
    Then I should see "Updated successfully"
