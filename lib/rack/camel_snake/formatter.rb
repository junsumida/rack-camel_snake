module Rack
  class CamelSnake
    module Formatter
      # hashのkeyを再帰的に変換: blockで変換処理を渡します
      def self.formatter(args, converter)
        case args
          when Hash
            args.reduce({}){ |hash, (key, value)| hash.merge(converter.call(key) => formatter(value, converter)) }
          when Array
            args.reduce([]){ |array, value| array << formatter(value, converter) }
          else
            args
        end
      end
    end
  end
end
