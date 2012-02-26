module DashboardHelper
  def render_message(message)
    if message do
      content_tag('div', :title => message[:title], :style => 'display: none') do
        content_tag('p', message[:body])
      end
    end
  end
end
