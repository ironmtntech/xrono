class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true

  default_scope :order => 'created_at DESC'

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user

  def date
    "#{self.created_at.time.month}-#{self.created_at.time.day}-#{self.created_at.time.year}"
  end

  def time_formatted
    if self.created_at.time.hour > 12
      @hour = self.created_at.time.hour - 12
      @ampm = 'pm'
    else
      @hour = self.created_at.time.hour
      @ampm = 'am'
    end

    if self.created_at.time.min < 10
      @min = '0' + self.created_at.time.min.to_s
    else
      @min = self.created_at.time.min
    end

    "#{@hour}:#{@min} #{@ampm}"
  end

end
