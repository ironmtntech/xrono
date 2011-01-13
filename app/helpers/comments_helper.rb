module CommentsHelper
  def comment_params
    _params = params.dup
    _params.delete(:controller)
    _params.delete(:action)
    _params
  end
end
