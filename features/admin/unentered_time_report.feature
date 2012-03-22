@wip
Feature: Unentered Time Report
  As an admin user
  I should be able to list users who didn't enter time

  Scenario: List users with unentered time
    Given I am an authenticated user with an admin role
    And a client "Test Client" exists with name: "Test Client"
    And a project "Test Project" exists with name: "Test Project", client: client "Test Client"
    And a ticket "Test Ticket" exists with name: "Test Ticket", project: project "Test Project"
    And a work_unit exists with description: "Test Work Unit", ticket: ticket "Test Ticket", hours: 1, scheduled_at: "2010-10-01 00:00:00", created_at: "2010-10-01 00:00:00"
    And a user exists with first_name: "Stan", last_name: "Lee", middle_initial: "M", email: "stanlee@example.com", password: "123456", password_confirmation: "123456"
    And the user "stanlee@example.com" has a "developer" role on project: "Test Project"
    When I go to path "/admin/unentered_time_report/2001-10-01"
    Then I should see a link with text "Stan M Lee"


  Scenario: List all hours entered by active users for the day
    Given I am an authenticated user with an admin role
    And a user exists with first_name: "Stan", last_name: "Lee", middle_initial: "M", email: "stanlee@example.com", password: "123456", password_confirmation: "123456"
    And a client "Test Client" exists with name: "Test Client"
    And a project "Test Project" exists with name: "Test Project", client: client "Test Client"
    And user is assigned to the project
    And a ticket "Test Ticket" exists with name: "Test Ticket", project: project "Test Project"
    And a work_unit exists with description: "Test Work Unit", ticket: ticket "Test Ticket", hours: 1, scheduled_at: "2010-10-01 12:00:00", created_at: "2010-10-01 12:00:00", user: user
    When I go to path "/admin/unentered_time_report/2010-10-01"
    Then I should see "1.0 hours entered."


  Scenario: Do not list user with unpaid work unit
    Given I am an authenticated user with an admin role
    And a user exists with first_name: "Stan", last_name: "Lee", middle_initial: "M", email: "stanlee@example.com", password: "123456", password_confirmation: "123456"   
    And a client "Test Client" exists with name: "Test Client"
    And a project "Test Project" exists with name: "Test Project", client: client "Test Client"
    And a ticket "Test Ticket" exists with name: "Test Ticket", project: project "Test Project"
    And a work_unit exists with description: "Test Work Unit", ticket: ticket "Test Ticket", hours: 1, scheduled_at: "2010-10-01 12:00:00", created_at: "2010-10-01 12:00:00", user: user
    When I go to path "/admin/unentered_time_report/2010-10-01"
    Then I should not see a link with text "Stan M Lee" within "#Friday"
