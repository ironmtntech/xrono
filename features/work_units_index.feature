Feature: Work Units Index

  Scenario: Visiting Work Units index page
    Given I am an authenticated user
    And a client "client1" exists with name: "client1"
    And a project "project1" exists with client: client "client1"
    And I am assigned to the project
    Then I go to the project page
    And I click on the tab Work units
    Then I should see a list of work units from that project
