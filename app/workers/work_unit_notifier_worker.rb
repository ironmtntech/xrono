class WorkUnitNotifierWorker
  include Sidekiq::Worker

  def perform work_unit_id, addresses=[]
    Notifier.work_unit_notification(work_unit_id, addresses).deliver
  end
end
