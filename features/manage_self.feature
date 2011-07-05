Feature: Self administration
  As a user
  I should be able to change my password

  @wip
  Scenario: Change password successfully
    Given I am an authenticated user "bobby@example.com" and password "changeme"
    When I go to the home page
    And I follow "Users"
    And I follow "Clark D Kent"
    Then I follow "Change Password"
    When I fill in "Password" with "newpass"
    And I fill in "Password Confirmation" with "newpass"
    And I press "Update"
    Then I should see "Successfully updated password"

  @wip
  Scenario: Change password failure

    When I go to the home page
    And I follow "Users"
    And I follow "Clark D Kent"
    And I follow "Change Password"
    When I fill in "Password" with "newpass"
    And I fill in "Password Confirmation" with "newpas"
    And I press "Update"
    Then I should see "Error changing password"

  Scenario: Change work_unit view details preference
    Given I am an authenticated user with a developer role
    And a client "test client" exists with name: "test client", initials: "TTC", status: "Suspended"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket "test ticket" exists with project: project "test project", name: "test ticket"
    And a work_unit exists with ticket: ticket "test ticket", description: "New description", hours: "1"
    When I go to the home page
    Then I should not see "New description" within "span"
    And I follow "Edit"
    And the "Expanded Calendar" checkbox should be checked
    And I press "Update"
    And I should see "New description" within "span"

    
