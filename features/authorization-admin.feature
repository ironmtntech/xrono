Feature: Admin Authorization
  As an admin
  I should have role-specific priveleges

  Scenario: List users (admin role)
    Given I am an authenticated user with an admin role
    Given the following user records:
      | first_name | last_name | middle_initial | email             | password  | role  |
      | admin      | mcadmin   | a              | admin@example.com | secret    | admin |
    When I go to the admin users page
    Then I should see "Admin A Mcadmin"

  Scenario: Create users (admin role)
    Given I am an authenticated user with an admin role
    Given I am on the admin user's new page
    When I fill in "First name" with "name 1"
    And I fill in "Last name" with "man"
    And I fill in "Middle initial" with "m"
    And I fill in "Email" with "name1@example.com"
    And I fill in "Password" with "secretpass"
    And I fill in "Password confirmation" with "secretpass"
    And I press "Create"
    Then I should see "Name 1 M Man"

  Scenario: Edit a user
    Given I am an authenticated user with an admin role
    Given a user exists with first_name: "Test", last_name: "Man", middle_initial: "T", email: "test@example.com", password: "secret", password_confirmation: "secret"
    When I go to the admin user's edit page
    Then I should see "First name"
    And I should see "Last name"
    And I should see "Middle initial"
    And I should see "Email"
    And I should see "Password"
    And I should see "Locked"
