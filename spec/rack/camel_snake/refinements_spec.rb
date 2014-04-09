require 'json'
require_relative '../../spec_helper'

class Mocked
  using Rack::CamelSnake::Refinements

  def to_camel(string)
    string.to_camel
  end

  def to_snake(string)
    string.to_snake
  end
end

describe Rack::CamelSnake::Refinements do
  let!(:mocked){ Mocked.new }

  describe 'to_camel' do
    it 'convert snake case into camel case' do
      %w(_snake_case snake_case snake___case snake_case_).each do |word|
        mocked.to_camel(word).should eq 'snakeCase'
      end
    end
  end

  describe 'to_snake' do
    it 'convert camel case into snake case' do
      mocked.to_snake('CamelCase').should eq 'camel_case'
      mocked.to_snake('CAMELCase').should eq 'camel_case'
    end
  end
end
