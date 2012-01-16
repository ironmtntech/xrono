require "rubygems"
require "hoe"
require "spec/rake/spectask"

require "./lib/version.rb"

hoe = Hoe.new("gchart", GChart::VERSION) do |p|
  p.rubyforge_name = "gchart"
  p.author = "John Barnette"
  p.email = "jbarnette@rubyforge.org"
  p.summary = "GChart uses the Google Chart API to create pretty pictures."
  p.description = p.paragraphs_of("README.txt", 2..5).join("\n\n")
  p.url = "http://gchart.rubyforge.org"
  p.changes = p.paragraphs_of("CHANGELOG.txt", 0..1).join("\n\n")
end

desc "Run all specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList["spec/**/*_spec.rb"]
  t.spec_opts = ["--options", "spec/spec.opts"]
end

desc "Run all specs and get coverage statistics"
Spec::Rake::SpecTask.new('spec:rcov') do |t|
  t.spec_files = FileList["spec/**/*_spec.rb"]
  t.rcov = true
  t.spec_opts = ["--options", "spec/spec.opts"]
end

Rake::Task[:default].prerequisites.clear
task :default => :spec
