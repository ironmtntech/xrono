class AddNotValidToFileAttachment < ActiveRecord::Migration
  def self.up
    add_column :file_attachments, :not_valid, :boolean
  end

  def self.down
    remove_column :file_attachments, :not_valid
  end
end
