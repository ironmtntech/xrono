module DashboardHelper
  def render_message(message)
    if message
      content_tag('div', :id => 'message', :title => message[:title], :style => 'display: none;') do
        content_tag('p', message[:body])
      end
    end
  end
end
