Given /^the following file attachments:$/ do |file_attachments|
  FileAttachment.create!(clients.hashes)
end

When /^I attach a file$/ do
  attach_file("file_attachment[attachment_file]", File.join(::Rails.root.to_s,'..', '..', 'features', 'step_definitions', 'file_attachment_steps.rb'))
end

