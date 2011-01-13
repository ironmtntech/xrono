class CreateFileAttachments < ActiveRecord::Migration
  def self.up
    create_table :file_attachments do |t|
      t.integer :client_id
      t.integer :ticket_id
      t.integer :project_id
      t.string :attachment_file_file_name
      t.string :attachment_file_file_content_type
      t.integer :attachment_file_file_size
      
      t.timestamps
    end
  end

  def self.down
    drop_table :file_attachments
  end
end
