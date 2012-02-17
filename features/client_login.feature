Feature: Client Login
  If a user has the client boolean set to true,
  then they should have different login behaviour.

  Scenario: Logging in with only one client
    Given I am an authenticated user with a client role
    And I only have 1 client
    And I visit /
    Then I should be on the clients client_login_client page

  Scenario: Logging in with more than one client
    Given I am an authenticated user with a client role
    And I only have 2 client
    And I visit /
    Then I should be on the client_login_clients page
