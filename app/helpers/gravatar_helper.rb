module GravatarHelper
  def show_gravatar_for(user)
    image_tag(user.gravatar_url) if user
  end
end
