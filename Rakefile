require "bundler/gem_tasks"
require 'bundler/setup'

task :default => [:spec]

desc 'run Rspec specs'
task :spec do
  ENV['RACK_ENV'] ||= 'test'
  sh 'rubocop'
  sh 'rspec'
end
