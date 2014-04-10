require 'rack/camel_snake/formatter'

module Rack
  class CamelSnake
    module Refinements
      refine Oj.singleton_class do
        def camelize(input)
          to_camel = lambda do |key|
            key.is_a?(String) ? key.to_camel : key
          end

          dump(Rack::CamelSnake::Formatter.formatter(load(input), to_camel))
        end

        def snakify(input)
          to_snake = lambda do |key|
            key.is_a?(String) ? key.to_snake : key
          end

          dump(Rack::CamelSnake::Formatter.formatter(load(input), to_snake))
        end
      end

      refine String do
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
    end
  end
end
