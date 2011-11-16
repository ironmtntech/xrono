module GravatarHelper
  def show_gravatar_for(user, size=80)
    image_tag(user.gravatar_url(:size => size)) if user
  end
end
