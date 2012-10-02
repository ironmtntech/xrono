
## Xrono
[![Travis CI Build Status](http://travis-ci.org/isotope11/xrono.png)](http://travis-ci.org/isotope11/xrono)

Xrono is a mature, open source, time tracking solution for your business.
Developed by Isotope11, Xrono is intended to be a core technology for smooth
operation of consultancies. Xrono allows team members to bill time against
clients, and then admins to easily export invoices and payroll into their
accounting systems. Beyond that, it has vacation time management, overtime,
client access and notification, and many more features. Xrono is currently under
active development, so feel free to check out our
[support](http://www.xrono.org/#support) section of our
[website](http://www.xrono.org/) if you have any questions.

### Demo site
[See it in action here.](http://demo.xrono.org)

You can log in as any of the following email addresses.  All have the password
'123456'

admin@xrono.org
dev@xrono.org
client@xrono.org

### Screenshots
Here are some screenshots of what it looks like:

#### The developer dashboard
![Dashboard](https://raw.github.com/isotope11/xrono/master/doc/xrono_dash.png)

#### A ticket view
![Ticket Details](https://raw.github.com/isotope11/xrono/master/doc/xrono_ticket.png)

### Continuous Integration Trends

#### Test Result Trend
![Test Result Trend](http://isotope11.selfip.com:8080/job/Xrono/test/trend)
#### Rcov coverage
![Rcov coverage](http://isotope11.selfip.com:8080/job/Xrono/rcov/graph)

### OAuth provider

Xrono is now an OAuth2 provider.  [Details on how you can totes verify this here.](https://github.com/applicake/doorkeeper/wiki/Testing-your-provider-with-OAuth2-gem)

### Development Installation
Fork, then clone the repository to your development environment

    gem install bundler
    bundle install
    cp config/database.yml.example config/database.yml
    # Change config/database.yml as you see fit to match your development environment needs
    rake db:reset db:test:clone spec cucumber

### Support
For support, please do one of the following:

* Post to our [Google Group](http://groups.google.com/group/xrono).
* Join us in IRC on Freenode [#xrono](irc://irc.freenode.net:6667/xrono)
* Create a ticket on our [GitHub Issue Tracker](http://github.com/isotope11/xrono/issues) for bugs.

### Contributing
We love contributions! please fork the project, make your changes in a branch,
test them properly - rspec for model/lib/helpers) and cucumber for integration
testing - then send us a pull request.
