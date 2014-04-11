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
    it 'convert snake_case into camelCase' do
      %w(_camel_case camel_case camel___case camel_case_).each do |word|
        expect(mocked.to_camel(word)).to eq 'camelCase'
      end
    end
  end

  describe 'to_snake' do
    it 'convert camelCase into snake_case' do
      expect(mocked.to_snake('snakeCase')).to eq 'snake_case'
      expect(mocked.to_snake('SnakeCase')).to eq 'snake_case'
      expect(mocked.to_snake('SNAKECase')).to eq 'snake_case'
    end
  end
end
