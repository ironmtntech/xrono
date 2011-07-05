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

  @javascript  
  Scenario: Change expanded calendar default preference
    Given I am an authenticated user with an admin role
    And a client "test client" exists with name: "test client", initials: "TTC"
    And a project "test project" exists with name: "test project", client: client "test client"
    And a ticket "test ticket" exists with project: project "test project", name: "test ticket"
    And I visit /
    When I select "test client" from "work_unit_client_id"
    And I select "test project" from "work_unit_project_id"
    And I select "test ticket" from "work_unit_ticket_id"
    And I select "Overtime" from "hours_type"
    And I fill in "Hours" with "2"
    And I fill in "work_unit_description" with "New description"
    And I press "Create Work Unit"
    Then I should see "New description" within "span"
    And I follow "Edit"
    And I uncheck "Expanded Calendar"
    Then show me the page
    And I press "Update"
    And I should not see "New description" within "span"

    
