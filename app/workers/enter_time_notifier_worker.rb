class EnterTimeNotifierWorker
  include Sidekiq::Worker

  def perform user
    Notifier.enter_time_notification(user).deliver
  end
end
