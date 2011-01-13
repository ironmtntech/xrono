# There was a bug in rack that threw a warning when passed a UTF-8 string.
# This block of code will patch it so it doesn't cause problems anymore and dirty
# up the test output
module Rack
  module Utils
    def escape(s)
      EscapeUtils.escape_url(s)
    end
  end
end
