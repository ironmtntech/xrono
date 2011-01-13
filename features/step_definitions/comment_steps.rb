Given /^the following comments:$/ do |comments|
  ::Comment.create!(comments.hashes)
end

