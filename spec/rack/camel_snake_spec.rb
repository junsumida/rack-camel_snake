require 'json'
require_relative '../spec_helper'

describe Rack::CamelSnake do
  include Rack::Test::Methods

  class MockedApp < Sinatra::Base
    post '/post' do
      JSON.dump(JSON.parse(request.body.read))
    end
  end

  def app
    @app ||= Rack::CamelSnake.new(MockedApp)
  end

  describe 'call' do
    let(:json){ { isDone:true, order:1, taskTitle:'hoge' } }

    it 'receives and returns camelCased json' do
      post '/post', JSON.dump(json)
      expect(last_response.body).to eq JSON.dump(json)
    end
  end

  describe 'rewrite_request/response' do
    let(:camel){ [{ 'isDone'  => 'hoge', 'order' => 1, 'taskTitle'  => 'title' }, { 'isDone'  => 'hoge', 'order' => 1, 'taskTitle'  => 'title' }] }
    let(:snake){ [{ 'is_done' => 'hoge', 'order' => 1, 'task_title' => 'title' }, { 'is_done' => 'hoge', 'order' => 1, 'task_title' => 'title' }] }

    it 'rewrite request with content_type == json' do
      mock_env_json = {
        'CONTENT_TYPE' => 'application/json',
        'CONTENT_LENGTH' => JSON.dump(camel).bytesize,
        'rack.input' => StringIO.new(JSON.dump(camel))
      }
      app.send(:rewrite_request_body_to_snake, mock_env_json)
      expect(JSON.parse(mock_env_json['rack.input'].read)).to eq snake
      expect(mock_env_json['CONTENT_LENGTH']).to eq JSON.dump(snake).bytesize
    end

    it 'not rewrite request with another content_type' do
      mock_env_json = {
        'CONTENT_TYPE' => 'text/html',
        'rack.input' => StringIO.new(JSON.dump(camel))
      }
      app.send(:rewrite_request_body_to_snake, mock_env_json)
      expect(JSON.parse(mock_env_json['rack.input'].read)).to eq camel
    end

    it 'rewrite response with content_type == json' do
      mock_response = [
        200,
        { 'Content-Type' => 'application/json' },
        [ JSON.dump(snake) ]
      ]
      response = app.send(:rewrite_response_body_to_camel, mock_response)
      expect(JSON.parse(response[2][0])).to eq camel
      expect(response[1]['Content-Length'].to_i).to eq JSON.dump(camel).bytesize
    end

    it 'not rewrite response with another content_type' do
      mock_response = [
        200,
        { 'Content-Type' => 'text/html' },
        [ JSON.dump(snake) ]
      ]
      response = app.send(:rewrite_response_body_to_camel, mock_response)
      expect(JSON.parse(response[2][0])).to eq snake
    end
  end

end
