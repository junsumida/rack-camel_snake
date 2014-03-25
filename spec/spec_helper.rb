require 'coveralls'

require 'rspec'
require 'rack/test'
require 'sinatra/base'

Coveralls.wear!
# load code after this line
require File.join(File.dirname(__FILE__), '..', 'lib', 'rack', 'camel_snake.rb')

RSpec.configure do |config|
  ENV['RACK_ENV'] ||= 'test'
end
