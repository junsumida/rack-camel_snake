module Rack
  class CamelSnake
    module Formatter
      # hashのkeyを再帰的に変換: blockで変換処理を渡します
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
