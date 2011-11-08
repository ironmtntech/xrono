Feature: File Attachment Management
  As a user
  I should be able to view, add, and hide file attachments

  Scenario: Add file attachments to client
    Given I am an authenticated user with an admin role
    And a client exists
    When I go to the client's page
    And I follow "Add File Attachment"
    And I attach a file
    And I press "Submit"
    Then I should be on the client's page
    And I should see "File Attachment created successfully" within ".alert-message"

  Scenario: Add file attachments to project
    Given I am an authenticated user with an admin role
    And a project exists
    When I go to the project's page
    And I follow "Add File Attachment"
    And I attach a file
    And I press "Submit"
    Then I should be on the project's page
    And I should see "File Attachment created successfully" within ".alert-message"

  Scenario: Add file attachments to ticket
    Given I am an authenticated user with an admin role
    And a ticket exists
    When I go to the ticket's page
    And I follow "Add File Attachment"
    And I attach a file
    And I press "Submit"
    Then I should be on the ticket's page
    And I should see "File Attachment created successfully" within ".alert-message"

  Scenario: Hide File Attachment
    Given I am an authenticated user with an admin role
    And a client exists
    When I go to the client's page
    And I follow "Add File Attachment"
    And I attach a file
    And I press "Submit"
    And I press "Mark as invalid"
    Then I should see "Attachment was marked as invalid"

  Scenario: Add file attachment unsuccessfully
    Given I am an authenticated user with an admin role
    And a project exists
    When I go to the project's page
    And I follow "Add File Attachment"
    And I press "Submit"
    And I should see "There was a problem saving the image." within ".alert-message"
