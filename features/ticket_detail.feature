Feature: Ticket board
  In order to show a good detailed view of a ticket upon double click
  Visitor
  Wants a modal with all the right info

  @javascript @wip
  Scenario: User double clicks ticket to see detailed view
    Given I am an authenticated user with an admin role
    Given a client "test client" exists with name: "test client"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket exists with project: project "test project", name: "test ticket"
    Given ticket "test ticket" has a work unit with description: "test work unit"  
    When I am on the project's page
    When I double-click "development_li ui-draggable"
    Then I should see "test work unit"

  @javascript @wip
  Scenario: List and add comments
    Given I am an authenticated user with an admin role
    Given a client "test client" exists with name: "test client"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket exists with project: project "test project", name: "test ticket"
    Given ticket "test ticket" has a work unit with description: "test work unit"  
    When I am on the project's page
    When I double-click "development_li ui-draggable"
    When I fill in "comment_comment" with "my comment"
    And I press "Post Comment"
    Then I should see "my comment" within "comment_body"

  @javascript @wip
  Scenario: Add file attachments to ticket
    Given I am an authenticated user with an admin role
    Given a client "test client" exists with name: "test client"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket exists with project: project "test project", name: "test ticket"
    Given ticket "test ticket" has a work unit with description: "test work unit"  
    When I am on the project's page
    When I double-click "development_li ui-draggable"
    And I attach a file
    And I press "Submit"
    Then I should be on the ticket's page
    And I should see "File Attachment created successfully" within "#flash_notice"

    @javascript
  Scenario: Client can add a ticket to an existing project
    Given I am an authenticated client on an existing project page
    Then I should be able to create a new ticket

