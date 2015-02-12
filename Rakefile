require 'bundler/gem_tasks'

begin
  require 'rspec/core/rake_task'
  task :default => :spec
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  puts 'rspec isn\'t available'
end
