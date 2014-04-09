module Rack
  class CamelSnake
    module Refinements
      refine Oj.singleton_class do
        def camelize(input)
          # send, respond_to, methodでは、refineで追加したメソッドを呼び出せない
          key_converter = lambda do |key|
            key.is_a?(String) ? key.to_camel : key
          end

          dump(CamelSnake.formatter(load(input), key_converter))
        end

        def snakify(input)
          # send, respond_to, methodでは、refineで追加したメソッドを呼び出せない
          key_converter = lambda do |key|
            key.is_a?(String) ? key.to_snake : key
          end

          dump(CamelSnake.formatter(load(input), key_converter))
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
