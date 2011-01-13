class FileAttachment < ActiveRecord::Base
  belongs_to :project
  belongs_to :client
  belongs_to :ticket
  has_attached_file :attachment_file
  validates_attachment_presence :attachment_file
end
