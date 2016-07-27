lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rake/clean'
require_relative 'lib/shippo/tasks/shippo'

CLEAN.include %w(pkg coverage *.gem)

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  STDERR.puts %Q(Unable to find rspec library.\nPlease run "bundle install" and then "bundle exec rake <task>")
  exit 1
end

begin
  require 'bundler'
  require 'bundler/gem_tasks'
rescue LoadError
  STDERR.puts %Q(Unable to find Bundler.\nPlease run "gem install bundler" first.)
  exit 2
end

task :default => [:spec]
