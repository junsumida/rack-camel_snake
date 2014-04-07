require 'oj'

module Oj::Formatter
  refine Oj.singleton_class do
    def camelize(input)
      dump(formatter(load(input), key_converter(to_camel)))
    end

    def snakify(input)
      dump(formatter(load(input), key_converter(to_snake)))
    end

    def key_converter(format)
      lambda do |key|
        key = format.call(key) if key.is_a?(String)
        key
      end
    end

    def to_camel
      lambda do |string|
      string.gsub(/_+([a-z])/){ |matched| matched.tr('_', '').upcase }
      .sub(/^(.)/){ |matched| matched.downcase }
      .sub(/_$/, '')
        end
    end

    def to_snake
      lambda do |string|
      string.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .tr('-', '_')
      .downcase
        end
    end

    # hashのkeyがstringの場合、symbolに変換します。hashが入れ子の場合も再帰的に変換します。
    # format引数に :to_snake, :to_camelを渡すと、応じたフォーマットに変換します
    def formatter(args, format)
      case args
        when Hash
          args.reduce({}){ |hash, (key, value)| hash.merge(format.call(key) => formatter(value, format)) }
        when Array
          args.reduce([]){ |array, value| array << formatter(value, format) }
        else
          args
      end
    end
  end
end

module Rack
  class CamelSnake
    using Oj::Formatter

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
        env['rack.input'] = StringIO.new(Oj.snakify(input))
      end
    end

    def rewrite_response_body_to_camel(response)
      response_header = response[1]
      response_body = response[2]

      if response_header['Content-Type'] =~ /application\/json/
        response_body.map!{|chunk|
          Oj.camelize(chunk)
        }
        response_header['Content-Length'] =
            response_body.reduce(0){ |s, i| s + i.bytesize }.to_s
      end

      response
    end

  end
end
