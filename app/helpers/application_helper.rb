module ApplicationHelper
  include Acl9Helpers

  def wrapper_class
    if current_user
      "wrapper #{current_user.full_width ? 'full_width' : nil}"
    else
      "wrapper"
    end
  end

end
