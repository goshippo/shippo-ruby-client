require 'yard'
require 'yard/rake/yardoc_task'
require 'rake/application'
require 'fileutils'
# Main namespace for Shippo specific Rake tasks

module Shippo
  DOC_FOLDER = 'doc'
end

namespace :shippo do
  YARD::Rake::YardocTask.new do |t|
    t.files = %w(lib/**/*.rb - README.md)
  end

  desc 'Generate ruby API documentation in folder ' + ::Shippo::DOC_FOLDER
  task :doc do
    FileUtils.rm_rf([::Shippo::DOC_FOLDER])
    Rake.application.invoke_task('shippo:yard')
    Kernel.system("open #{::Shippo::DOC_FOLDER}/index.html")
  end
end
