Feature: Client Login
  If a user has the client boolean set to true,
  then they should have different login behaviour.

  Scenario: Logging in with client - true
    Given I am an authenticated user with a client role
      And I visit /
     Then I should see "Clients" 
