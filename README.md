# Xrono
[![Travis CI Build Status](http://travis-ci.org/isotope11/xrono.png)](http://travis-ci.org/isotope11/xrono)

Xrono is a mature, open source, time tracking solution for your business. Developed by Isotope11, Xrono is intended to be a core technology for smooth operation of consultancies. Xrono allows team members to bill time against clients, and then admins to easily export invoices and payroll into their accounting systems. Beyond that, it has vacation time management, overtime, client access and notification, and many more features. Xrono is currently under active development, so feel free to check out our support[http://www.xrono.org/#support] section of our website[http://www.xrono.org/] if you have any questions.

## Development Installation

* Fork, then clone the repository to your development environment
* If you are using rvm, create a .rvmrc
* gem install bundler
* bundle install
* If you get errors involving linecache19, you may need to do something like: "gem install ruby-debug19 -- --with-ruby-include=<path to your ruby install>" then re-run "bundle install"
* cp config/database.yml.example config/database.yml
* Change config/database.yml as you see fit to match your development environment needs
* rake db:reset
* rake db:test:clone
* rake spec
* rake cucumber

## Support
For support, please do one of the following:

* Post to our GoogleGroup[http://groups.google.com/group/xrono].
* Join us in IRC on Freenode #xrono[irc://irc.freenode.net:6667/xrono]
* Create a ticket on our GitHub Issue Tracker[http://github.com/isotope11/xrono/issues] for bugs.
* View ongoing/outstanding work on Xrono via PivotalTracker[https://www.pivotaltracker.com/projects/136852]

## Contributing

We love contributions! please fork the project, make your changes in a branch, test them properly (rspec for model/lib/helpers) and cucumber for integration testing, then send us a pull request, or mention it in our google group.

If you find a bug, please post it in the GitHub Issue Tracker
