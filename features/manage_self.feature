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
    Given I am an authenticated user "dev@xrono.org" and password "123456"
    When I go to the home page
    And I follow "Edit Kira L Yagami"
    Then I should see "[-] by default"
    And I press "Toggle Work Unit Views"
    Then I should see "[+] by default"

    
