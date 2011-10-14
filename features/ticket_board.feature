Feature: Ticket board
  In order to manage states of tickets
  Visitor
  wants a draggable/droppable ticket board

  @javascript
  Scenario: Change a ticket's state
    Given I am an authenticated user with an admin role
    Given a client "test client" exists with name: "test client"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket exists with project: project "test project", name: "test ticket"
    When I am on the project's page
    When I drag "test ticket" fridge ticket to "development_ul"
    Then ticket "test ticket" should appear in "development" bucket
    Then the ticket named "test ticket" should have a state of "development"
    When I drag "test ticket" development ticket to "peer_review_ul"
    Then ticket "test ticket" should appear in "peer_review" bucket
    Then the ticket named "test ticket" should have a state of "peer_review"
    When I drag "test ticket" peer_review ticket to "user_acceptance_ul"
    Then ticket "test ticket" should appear in "user_acceptance" bucket
    Then the ticket named "test ticket" should have a state of "user_acceptance"
    When I drag "test ticket" user_acceptance ticket to "archived_ul"
    Then ticket "test ticket" should appear in "archived" bucket
    Then the ticket named "test ticket" should have a state of "archived"
    Then the ticket named "test ticket" in "archived" should have html id equal to ActiveRecord model id
