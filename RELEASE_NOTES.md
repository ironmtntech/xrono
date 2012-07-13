03/23/2012

  - Add totals to weekly time report

02/27/2012

  - Bootstrap2 upgrade complete and in place.
  - Clean up various views to be more idiomatic rails3
  - Clean up display in general to be more happy-to-be-bootstrap
  - Change pie charts to progress bars
  - Make most active project show up at top of projects listing.
  - factor out a show_message method from dashboard code.

02/22/2012

  - Link to projects in two week time report on dash.

02/16/2012

  - Added better client dashboard to see monthly work unit statistics.

02/07/2012

  - Refactored the way that work_units are loaded in the calendar.

02/06/2012

  - Upgraded to rails 3.2
  - Removed fnordmetric as it was not compatible with the rails 3.2 upgrade
  - Ticket descriptions now render with markdown

01/30/2012

  - Made minor modifications to the api for the cli app

01/27/2012

  - Added data vault to store username and passwords

01/24/2012

  - Added release note and xrono note functionality to projects

01/23/2012

  - Added ability to create tickets while creating a new work unit

01/04/2012

  - Added realtime metrics
  - Added github integration
  - Bar graphs for work units
  - Fixed a bug in work unit creation
    > Now when you try to submit a work unit without a ticket you get a dialog

12/25/2011

  - New client login feature:
    > Users can now be given special login behavior via a "Client Login" checkbox
    > Users with "Client Logins" will be isolated to the client_login namespace
    > Users with "Client Logins" have an awesome experience to manage (add/update) their contacts and view their work units
    > Users with "Client Logins" will also be able to see reporting on a per-ticket basis that shows a fancy pie chart.
      The pie chart displays a percentage of completion based on estimated time to complete a ticket and the ammount of
      that estimated time that remains.

12/15/2011

  - Email notifications to clients as background jobs using Resque::Mailer
  - Styling changes to the admin/invoices page
  - A centralized reporting page for admins.
  - Ticket numbers on the project's index.
  - Reporting on Tickets based on estimated time to complete a ticket versus total effective hours on the ticket.
  - Showing the add ticket partial to admins.

EARLIER

  - No release notes were really kept prior to this date.  Oops :)
