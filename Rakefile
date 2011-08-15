#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end
  
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:cucumber)

namespace :doc do 
  RDoc::Task.new(:rdoc) do |rdoc|
    rdoc.rdoc_dir = 'rdoc'
    rdoc.title    = 'Gricer'
    rdoc.options << '--line-numbers' << '--inline-source'
    rdoc.rdoc_files.include('README.rdoc')
    rdoc.rdoc_files.include('lib/**/*.rb')
  end
  
  begin
    require 'yard'
  
    YARD::Rake::YardocTask.new(:yard) do |t|
      t.files   = ['lib/**/*.rb', 'app/**/*.rb', '-', 'README.rdoc', 'MIT-LICENSE']
      t.options = ['--title', 'API - Gricer - Web Analytics Tool for Rails 3.1', '--private', '--protected'] 
    end
  rescue
  end
end


APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'



desc "Run RSpec and Cucumber tests"
task :test => [:spec, :cucumber]
task :default => :test