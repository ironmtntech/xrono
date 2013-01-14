class Notifier < ActionMailer::Base
  default :from => "no-reply@xrono.org"

  def daily(client_id)
    @client = Client.find(client_id)
    @hours = WorkUnit.for_client(@client).sum(:hours)
    @uninvoiced_hours = WorkUnit.for_client(@client).not_invoiced.sum(:hours)
    mail(:to => Contact.for_client(@client).receives_email.map(&:email_address),
         :bcc => ["bcc@xrono.org"],
         :subject => 'Daily Hours Summary') {|f| f.text}
  end

  def work_unit_notification(work_unit_id, addresses)
    addresses += %w(laird@isotope11.com josh@isotope11.com)
    @work_unit = WorkUnit.find work_unit_id
    mail(:bcc => addresses, :subject => "[Xrono] Work Unit: #{@work_unit.guid}") {|f| f.text}
  end

  def enter_time_notification(user_id)
    user = User.find(user_id)
    mail(:to => user.email, :subject => "[Xrono] You have not yet entered time for today, please do it now.")
  end

  def remote_workday_request(request_id)
    request = RemoteWorkdayRequest.find(request_id)
    @user = request.user.name
    @url = "xrono.isotope11.com"
    @date = request.date_requested
    mail(:bcc => ["laird@isotope11.com", "josh@isotope11.com"], :subject => "[Xrono] #{@user} is requesting approval for a remote work day")
  end

  def remote_workday_response(request_id)
    request = RemoteWorkdayRequest.find(request_id)
    @response = request.state
    @date = request.date_requested
    mail(:to => request.user.email, :subject => "[Xrono] Remote Work Day Request.")
  end

end
