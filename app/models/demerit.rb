class Demerit < ActiveRecord::Base
  attr_accessible :user_id

  belongs_to :user

  scope :unresolved, lambda { where("resolved != ?", true ) }

end
