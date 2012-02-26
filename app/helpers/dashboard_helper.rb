module DashboardHelper
  def render_message(message)
    content_tag('p', message[:body]) if message
  end
end
