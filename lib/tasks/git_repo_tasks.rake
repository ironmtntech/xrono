namespace :git_repos do
  desc "Clone or update git repos for all projects"
  task :send => :environment do
    Client.active.all.each do |c|
      c.projects.with_git_repos.all.each do |p|
      end
    end
  end
end
