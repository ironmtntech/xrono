require 'grit'
require 'fileutils'
namespace :git_repos do
  desc "Clone or update git repos for all projects"
  task :create => :environment do
    workspace_dir = File.join(Rails.root, "tmp", "xrono_git_workspace")
    puts "Creating workspace directory at #{workspace_dir}"
    FileUtils.rm_rf File.join(workspace_dir) if Dir.exists?(workspace_dir)
    Dir.mkdir( workspace_dir )
    Client.active.all.each do |client|
      puts "Working on client #{client.name}"
      #make the client directories
      client_directory = File.join(workspace_dir,  client.name.gsub("//","").gsub(" ","_").gsub("/",""))
      puts "\tCreating client directory at #{client_directory}"
      Dir.mkdir(client_directory) unless Dir.exists?(client_directory)

      #Loop over the projects and clone or update the repos
      client.projects.with_git_repos.all.each do |project|
        puts "\t\tWorking on Project #{project.name}"
        project_directory = File.join(client_directory, project.name.gsub("//","").gsub(" ","_").gsub("/",""))
        grit = Grit::Git.new('/tmp/')
        puts "\t\t\tAttempting to clone #{project.git_repo_url} to #{project_directory}"
        begin
          grit.clone({:quiet => false, :verbose => true, :progress => true}, project.git_repo_url, project_directory)
        rescue Grit::Git::GitTimeout
          next
        end
        xrono_markdown = File.join(project_directory, "XRONO.md")
        release_notes  = File.join(project_directory, "RELEASE_NOTES.md")

        if File.exists?(xrono_markdown)
          project.xrono_notes = File.read(xrono_markdown)
        else
          project.xrono_notes = nil
        end
        if File.exists?(release_notes)
          project.release_notes = File.read(release_notes)
        else
          project.release_notes = nil
        end
        project.save
      end
    end
    puts "Cleaning up workspace directory"
    FileUtils.rm_rf File.join(workspace_dir)
  end
end
