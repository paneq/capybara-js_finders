#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

Bundler::GemHelper.install_tasks
require 'rdoc/task'
require 'rake/testtask'
require 'rake'

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Capybara JS Finders'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end


task :default => :test

task :script do
  require "capybara-js_finders"
  puts Capybara::JsFinders::SCRIPT
end

namespace :find_cell_tests do
  task :app do
    $LOAD_PATH << './test'
    require 'unit/find_cell_tests/app/app'
    FindCellTests::App.run!
  end
end