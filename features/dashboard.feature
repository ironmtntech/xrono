Feature: Dashboard

  Scenario: Total hours for each day
    Given I am an authenticated user
    And I have a "Normal" work unit scheduled today for "3.0" hours
    And I have an "Overtime" work unit scheduled today for "2.0" hours
    When I go to the home page
    Then I should see "Total: 6.0" within ".calendar_foot"
    Then I should see "Current: 6.0" within "#current_hours"

  Scenario: Non-entered time warning
    Given I am an authenticated user with a developer role
    And I have no work units for the previous day
    When I go to the home page
    Then I should see "You have not entered any time for the previous working day." within "#message"
