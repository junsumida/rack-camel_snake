require 'oj'
require_relative '../../spec_helper'

class Mocked
  using Rack::CamelSnake::Refinements

  def to_camel(arg)
    Oj.camelize(arg)
  end

  def to_snake(arg)
    Oj.snakify(arg)
  end
end

describe Rack::CamelSnake::Formatter do
  describe 'formatter' do
    let!(:mocked){ Mocked.new }
    let!(:snake_hash){  Oj.dump('is_done' => 'hoge', 'order' => 1, 'task_title' => 'title') }
    let!(:camel_hash){  Oj.dump('isDone'  => 'hoge', 'order' => 1, 'taskTitle'  => 'title') }
    let!(:snake_array){ Oj.dump([ snake_hash, snake_hash, snake_hash ]) }
    let!(:camel_array){ Oj.dump([ camel_hash, camel_hash, camel_hash ]) }

    context 'given snake cases' do
      it 'converts keys into camelCase, and the keys should be a string.' do
        expect(mocked.to_camel(snake_hash)).to eq camel_hash
        expect(mocked.to_camel(snake_array)).to eq camel_array
      end
    end

    context 'given camel cases' do
      it 'converts keys into snake_case, and the keys should be a symbol.' do
        expect(mocked.to_snake(camel_hash)).to eq snake_hash
        expect(mocked.to_snake(camel_array)).to eq snake_array
      end
    end
  end

end
