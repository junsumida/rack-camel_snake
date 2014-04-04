# -*- coding: utf-8 -*-
require 'json'

class String
  def to_camel
    gsub(/_+([a-z])/){ |matched| matched.tr('_', '').upcase }
      .sub(/^(.)/){ |matched| matched.downcase }
      .sub(/_$/, '')
  end

  def to_snake
    gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .tr('-', '_')
      .downcase
  end
end

class Hash
  def traversal(callback)
    converted = map{|k, v|
      [ callback.call(k), v.respond_to?(:traversal) ? v.traversal(callback) : v ]
    }.flatten
    Hash[ *converted ]
  end
end

class Array
  def traversal(callback)
    map{ |v| v.respond_to?(:traversal) ? v.traversal(callback) : v }
  end
end

module Rack
  class CamelSnake
    def initialize(app)
      @app = app
    end

    def call(env)
      rewrite_request_body_to_snake(env)

      response = @app.call(env)

      rewrite_response_body_to_camel(response)
    end

    private

    def rewrite_request_body_to_snake(env)
      if env['CONTENT_TYPE'] == 'application/json'
        input = env['rack.input'].read
        env['rack.input'] = StringIO.new(JSON.dump(formatter(JSON.parse(input), :to_snake)))
      end
    end

    def rewrite_response_body_to_camel(response)
      response_header = response[1]
      response_body = response[2]

      if response_header['Content-Type'] =~ /application\/json/
        response_body.map!{|chunk|
          JSON.dump(formatter(JSON.parse(chunk), :to_camel))
        }
        response_header['Content-Length'] =
            response_body.reduce(0){ |s, i| s + i.bytesize }.to_s
      end

      response
    end

    # hashのkeyがstringの場合、symbolに変換します。hashが入れ子の場合も再帰的に変換します。
    # format引数に :to_snake, :to_camelを渡すと、応じたフォーマットに変換します
    def formatter(args, format)
      callback = lambda {|i|
        i.respond_to?(format) ? i.send(format) : i
      }
      args.traversal(callback)
    end
  end
end
