module DataMaps
  module Converter
    # Adds a prefix to the given data
    #
    # @since 0.0.1
    class Prefix < Base
      # The apply method to adds a prefix to the given data
      #
      # @param [mixed] data
      def apply(data)
        case data
          when Array then data.map{ |v| "#{option}#{v}" }
          when Hash then Hash[data.map{ |k,v| [k,"#{option}#{v}"] }]
          else "#{option}#{data}"
        end
      end
    end

    # Adds a postfix to the given data
    #
    # @since 0.0.1
    class Postfix < Base
      # The apply method to adds a postfix to the given data
      #
      # @param [mixed] data
      def apply(data)
        case data
          when Array then data.map{ |v| "#{v}#{option}" }
          when Hash then Hash[data.map{ |k,v| [k,"#{v}#{option}"] }]
          else "#{data}#{option}"
        end
      end
    end
  end
end
