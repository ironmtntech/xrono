class DailyNotifierWorker
  include Sidekiq::Worker

  def perform client_id
    Notifier.daily(client_id).deliver
  end
end
