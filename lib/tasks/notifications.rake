namespace :notifications do
  desc "Sends notifications"
  task :send => :environment do
    Client.all.each do |c|
      DailyNotifierWorker.perform_async(c.id)
    end
  end
end
