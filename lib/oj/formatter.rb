module Oj
  module Formatter
    refine Oj.singleton_class do
      def camelize(input)
        dump(CamelSnake.formatter(load(input), :to_camel))
      end

      def snakify(input)
        dump(CamelSnake.formatter(load(input), :to_snake))
      end
    end
  end
end

module CamelSnake
  def self.to_camel(string)
    string.gsub(/_+([a-z])/){ |matched| matched.tr('_', '').upcase }
    .sub(/^(.)/){ |matched| matched.downcase }
    .sub(/_$/, '')
  end

  def self.to_snake(string)
    string.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
    .gsub(/([a-z\d])([A-Z])/, '\1_\2')
    .tr('-', '_')
    .downcase
  end

  # hashのkeyがstringの場合、symbolに変換します。hashが入れ子の場合も再帰的に変換します。
  # format引数に :to_snake, :to_camelを渡すと、応じたフォーマットに変換します
  def self.formatter(args, format)
    key_converter = lambda do |key|
      key = lambda(&method(format)).call(key) if key.is_a?(String)
      key
    end

    case args
      when Hash
        args.reduce({}){ |hash, (key, value)| hash.merge(key_converter.call(key) => formatter(value, format)) }
      when Array
        args.reduce([]){ |array, value| array << formatter(value, format) }
      else
        args
    end
  end
end
