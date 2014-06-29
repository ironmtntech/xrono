class SurveySender

  def initialize
    @users = User.developers.unlocked.uniq
  end

  def run
    @users.each do |user|
      #address how many projects one dev should be on
      projects = user.roles.select{|x| x.authorizable.client.active?}.map{|x| x.authorizable}
      Notifier.project_survey(user, projects).deliver 
    end
  end
end
