Feature: API - V1 - Client Management
  As a user
  I should be able to manage clients through an API

  @wip
  Scenario: List clients
    Given I am an authenticated user
    Given the following clients:
      |name  |status    |guid|
      |name 1|Active    |1   |
      |name 2|Inactive  |2   |
      |name 3|Suspended |3   |
      |name 4|Active    |4   |
    When I go to path "/api/v1/clients.json":
    Then I should see JSON:
      """
      [
        {"client": {
          "name": "name 1",
          "status": "Active",
          "guid": "1"
        }},
        {"client": {
          "name": "name 2",
          "status": "Inactive",
          "guid": "2"
        }},
        {"client": {
          "name": "name 3",
          "status": "Suspended",
          "guid": "3"
        }},
        {"client": {
          "name": "name 4",
          "status": "Active",
          "guid": "4"
        }}
      ]
      """

  @wip
  Scenario: Show client
    Given I am an authenticated user
    Given the following clients:
      |name  |status    |guid|
      |name 1|Active    |1a  |
      |name 2|Inactive  |2a  |
      |name 3|Suspended |3a  |
      |name 4|Active    |4a  |
    When I go to path "/api/v1/clients/3a.json":
    Then I should see JSON:
      """
      {"client": {
        "name": "name 3",
        "status": "Suspended",
        "guid": "3a"
      }}
      """
