module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

    when /^the contacts page$/
      client_contacts_path

    when /^the login page$/
      '/login'

    when /path "(.+)"/
      $1

    # the following are examples using path_to_pickle
    when /^the admin #{capture_model}(?:'s)? page$/
      path_to_pickle 'admin', $1

    when /^the admin invoices page$/
      '/admin/invoices'

    when /^the admin #{capture_model}(?:'s)? (.+?) page$/
      path_to_pickle 'admin', $1, :extra => $2

    when /^the admin payroll show page for #{capture_model}$/
      user = model!($1)
      "/admin/payroll/#{user.id}"

    when /^the dashboard #{capture_model}(?:'s)? page$/                           # eg. the forum's page
      path_to_pickle 'dashboard', $1

    when /^#{capture_model}(?:'s)? page$/                           # eg. the forum's page
      path_to_pickle $1

    when /^#{capture_model}(?:'s)? #{capture_model}(?:'s)? page$/   # eg. the forum's post's page
      path_to_pickle $1, $2

    when /^#{capture_model}(?:'s)? #{capture_model}(?:'s)? #{capture_model}(?:'s)? page$/   # eg. the forum's category's post's page
      path_to_pickle $1, $2, $3

    when /^#{capture_model}(?:'s)? #{capture_model}(?:'s)? #{capture_model}(?:'s)? #{capture_model}(?:'s)? page$/   # eg. the forum's category's post's comment's page
      path_to_pickle $1, $2, $3, $4

    when /^#{capture_model}(?:'s)? #{capture_model}'s #{capture_model}(?:'s)? #{capture_model}(?:'s)? (.+?) page$/  # eg. the forum's category's post's comment's moderations page
      path_to_pickle $1, $2, $3, $4, :extra => $5                           #  or the forum's post's comment's moderation's edit page

    when /^#{capture_model}(?:'s)? #{capture_model}'s #{capture_model}(?:'s)? (.+?) page$/  # eg. the forum's category's post's comments page
      path_to_pickle $1, $2, $3, :extra => $4                           #  or the forum's category's post's edit page

    when /^#{capture_model}(?:'s)? #{capture_model}'s (.+?) page$/  # eg. the forum's post's comments page
      path_to_pickle $1, $2, :extra => $3                           #  or the forum's post's edit page

    when /^#{capture_model}(?:'s)? (.+?) page$/                     # eg. the forum's posts page
      path_to_pickle $1, :extra => $2                               #  or the forum's edit page


    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
