task :reinstall do
  [ %q(chmod -R o+r .),
    %q(rm -f *.gem),
    %q(rm -rf build),
    %q(gem uninstall -quiet -a --executables warp-dir 2> /dev/null; true),
    %q(gem build warp-dir.gemspec)
  ].each do |command|
    sh command
  end

  sh <<-EOF.gsub(%r{^\s+}m, '')
    export gem_file=$(ls -1 *.gem | tail -1)
    export gem_name=${gem_file//.gem/}
    if [ "$(which ruby)" == "/usr/bin/ruby" ]; then
      gem install $gem_file -n /usr/local/bin --no-ri --no-rdoc
    else
      gem install $gem_file --no-ri --no-rdoc
    fi
  EOF
end

namespace :development do
  desc 'Setup temporary Gemfile, install all dependencies, and remove Gemfile'
  task :install => [:setup, :cleanup]

  desc 'Setup temporary Gemfile and install all dependencies.'
  task :setup do
    sh %q{
      echo "source 'https://rubygems.org'; gemspec" > Gemfile
      [[ -n $(which bundle) ]] || gem install bundler --no-ri --no-rdoc
      bundle install
    }.gsub(%r{^\s+}m, '')
  end

  task :cleanup do
    sh %q{ rm -f Gemfile }
  end

  namespace :bundler do
    task :load do
      require 'bundler'
      require 'bundler/gem_tasks'
    end
    desc "Invoke Bundler's 'release' task to push the gem to RubyGems.org"
    task :release => [ :setup, :load ] do
      Rake::Task['release'].invoke
      Rake::Task['development:cleanup'].invoke
    end

    desc 'Package and install the gem locally'
    task :install => [ :setup, :load ] do
      Rake::Task['install:local'].invoke
      Rake::Task['development:cleanup'].invoke
    end
  end
end

require 'rake/clean'
CLEAN.include %w(pkg coverage *.gem)

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

task :spec => [ 'development:setup' ] do
  Rake::Task['development:cleanup'].invoke
end

task :default => [:spec]
