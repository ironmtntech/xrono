class RemoteWorkdayRequest < ActiveRecord::Base
  attr_accessible :description, :user_id, :state, :date_requested

  belongs_to :user

  after_create :remote_workday_request

  state_machine :state, :initial => :incomplete do
    after_transition :pending => :approved, :do => :deduct_from_user_account
    after_transition :pending => :denied, :do => :remote_workday_response
#    after_transition :pending => [:approved, :denied], :do => :remote_workday_response
    #
    event :submit do
      transition [:incomplete] => :pending
    end

    event :approve do
      transition [:pending] => :approved
    end

    event :deny do
      transition [:pending] => :denied
    end

    state :incomplete
    state :pending
    state :approved
    state :denied
  end

  def deduct_from_user_account
    user.redeem_remote_work_day!
    remote_workday_response
  end

  def remote_workday_request
    submit!
    RemoteWorkdayRequestNotifierWorker.perform_async(id)
  end

  def remote_workday_response
    RemoteWorkdayResponseNotifierWorker.perform_async(id)
  end

end
