Given /^user is assigned to the project$/ do
  User.last.has_role!(:developer, Project.last)
end
