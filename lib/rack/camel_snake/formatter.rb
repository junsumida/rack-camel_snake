module Rack
  class CamelSnake
    module Formatter
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
