require 'yard'
require 'yard/rake/yardoc_task'
require 'rake/application'
require 'fileutils'
# Main namespace for Shippo specific Rake tasks

module Shippo
  DOC_FOLDER = 'doc'
end

YARD::Rake::YardocTask.new do |t|
  t.files = %w(lib/**/*.rb - README.md CHANGELOG.md)
end

namespace :doc do
  desc 'Generate API documentation and preview in browser'
  task :read do
    FileUtils.rm_rf([::Shippo::DOC_FOLDER])
    Rake.application.invoke_task('yard')
    Kernel.system("open #{::Shippo::DOC_FOLDER}/index.html")
  end
end
