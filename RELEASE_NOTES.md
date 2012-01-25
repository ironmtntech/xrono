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
