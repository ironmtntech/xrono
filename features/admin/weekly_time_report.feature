Feature: Weekly Time Report
  As an admin user
  I should be able to list users' calendars

  Scenario: List users with time
    Given I am an authenticated user with an admin role
    And a user exists with first_name: "Stan", last_name: "Lee", middle_initial: "M", email: "stanlee@example.com", password: "123456", password_confirmation: "123456"
    And the user "stanlee@example.com" has a "developer" role
    And a client "Test Client" exists with name: "Test Client"
    And a project "Test Project" exists with name: "Test Project", client: client "Test Client"
    And a ticket "Test Ticket" exists with name: "Test Ticket", project: project "Test Project"
    And a work_unit exists with description: "Test Work Unit", ticket: ticket "Test Ticket", hours: 1, scheduled_at: "2010-10-01 00:00:00", created_at: "2010-10-01 00:00:00"
    When I go to path "/admin/weekly_time_report/2001-10-01"
    Then I should see "Stan M Lee"
