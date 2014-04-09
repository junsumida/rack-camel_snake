module Rack
  class CamelSnake
    module Formatter
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

      # hashのkeyを再帰的に変換します。
      # key_converterにkeyに対して施す処理をlambda等で渡します
      def self.formatter(args)
        key_converter = lambda do |key|
          key.is_a?(String) ? yield(key) : key
        end

        case args
          when Hash
            args.reduce({}){ |hash, (key, value)| hash.merge(key_converter.call(key) => formatter(value){ yield }) }
          when Array
            args.reduce([]){ |array, value| array << formatter(value){ yield } }
          else
            args
        end
      end
    end
  end
end
