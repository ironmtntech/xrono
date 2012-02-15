Given /^I only have (\d+) client$/ do |num_clients|
  num_projects = num_clients.to_i - Client.for_user(@current_user).all.count #for some reason count without the all was returning {1=>1}
  num_projects.times do |i|
    p = Project.make
    @current_user.has_role!(:client, p)
  end
  Client.for_user(@current_user).all.count.should == num_clients.to_i
end
