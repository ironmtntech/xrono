namespace :notifications do
  desc "Sends notifications"
  task :send => :environment do
    Client.all.each do |c|
      Notifier.daily(c).deliver
    end
  end
end
