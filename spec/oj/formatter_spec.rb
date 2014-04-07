require 'json'
require 'oj'
require_relative '../spec_helper'

describe Oj::Formatter do
end

describe CamelSnake do
  describe 'to_camel' do
    it 'convert snake case into camel case' do
      %w(_snake_case snake_case snake___case snake_case_).each do |word|
        CamelSnake::to_camel(word).should eq 'snakeCase'
      end
    end
  end

  describe 'to_snake' do
    it 'convert camel case into snake case' do
      CamelSnake::to_snake('CamelCase').should eq 'camel_case'
      CamelSnake::to_snake('CAMELCase').should eq 'camel_case'
    end
  end

  describe 'formatter' do
    let!(:snake_hash){ { 'is_done' => 'hoge', 'order' => 1, 'task_title' => 'title' } }
    let!(:camel_hash){ { 'isDone'  => 'hoge', 'order' => 1, 'taskTitle'  => 'title' } }
    let(:snake_array){ [ snake_hash, snake_hash, snake_hash ] }
    let(:camel_array){ [ camel_hash, camel_hash, camel_hash ] }

    context 'given :to_camel' do
      it 'converts keys into camelCase, and the keys should be a string.' do
        CamelSnake::formatter(snake_hash,  :to_camel).should eq camel_hash
        CamelSnake::formatter(snake_array, :to_camel).should eq camel_array
      end
    end

    context 'given :to_snake' do
      it 'converts keys into snake_case, and the keys should be a symbol.' do
        CamelSnake::formatter(camel_hash,  :to_snake).should eq snake_hash
        CamelSnake::formatter(camel_array, :to_snake).should eq snake_array
      end
    end
  end

end
