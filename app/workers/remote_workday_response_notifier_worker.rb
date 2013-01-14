class RemoteWorkdayResponseNotifierWorker
  include Sidekiq::Worker

  def perform remote_workday_request_id
    Notifier.remote_workday_response(remote_workday_request_id).deliver
  end
end
