require 'rack/camel_snake/formatter'

module Rack
  class CamelSnake
    module Refinements
      extend Rack::CamelSnake::Formatter

      refine Oj.singleton_class do
        def camelize(input)
          dump(Rack::CamelSnake::Formatter.formatter(load(input)){ |key| key.to_camel })
        end

        def snakify(input)
          dump(Rack::CamelSnake::Formatter.formatter(load(input)){ |key| key.to_snake })
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
