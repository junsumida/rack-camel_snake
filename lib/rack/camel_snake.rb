require 'oj'
require 'oj/formatter'

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
      response_body   = response[2]

      if response_header['Content-Type'] =~ /application\/json/
        response_body.map!{ |chunk| Oj.camelize(chunk) }
        response_header['Content-Length'] =
            response_body.reduce(0){ |s, i| s + i.bytesize }.to_s
      end

      response
    end
  end
end
