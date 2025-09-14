require 'rspec/core/rake_task'
require 'json'

RSpec::Core::RakeTask.new(:spec)

desc "Extract Van Gogh paintings"
task :extract do
  ruby 'extract_paintings.rb'
end

desc "Run tests"
task :test => :spec

desc "Test layout compatibility"
task :test_layouts do
  system('bundle exec rspec spec/layout_compatibility_spec.rb')
end

desc "Validate output"
task :validate do
  result = JSON.parse(File.read('output/extracted-paintings.json'))
  puts "Artworks: #{result['artworks'].length}"
  puts "With images: #{result['artworks'].count { |a| a['image'] }}"
end

desc "Complete workflow"
task :workflow => [:test, :test_layouts, :extract, :validate]

task :default => :extract