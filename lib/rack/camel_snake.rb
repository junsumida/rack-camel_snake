require 'oj'
require 'rack/camel_snake/refinements'

module Rack
  class CamelSnake
    using Rack::CamelSnake::Refinements

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
      response_body   = response[2]

      if response_header['Content-Type'] =~ /application\/json/
        response_body.map!{ |chunk| Oj.camelize(chunk) }
        response_header['Content-Length'] =
            response_body.reduce(0){ |s, i| s + i.bytesize }.to_s
      end

      response
    end

    # hashのkeyがstringの場合、symbolに変換します。hashが入れ子の場合も再帰的に変換します。
    # key_converterにkeyに対して施す処理をlambda等で渡します
    def self.formatter(args, key_converter)
      case args
        when Hash
          args.reduce({}){ |hash, (key, value)| hash.merge(key_converter.call(key) => formatter(value, key_converter)) }
        when Array
          args.reduce([]){ |array, value| array << formatter(value, key_converter) }
        else
          args
      end
    end
  end
end
