module DataMaps
  module Converter
    # Converts numeric values
    #
    # @since 0.0.1
    class Keys < Base
      # The after initialize callback
      def after_initialize
        @option = option.with_indifferent_access
      end

      # The execute method to convert the keys of given data
      #
      # @param [mixed] data
      def execute(data)
        case data
          when Hash then Hash[data.map{ |k,v| [option[k] || k, v] }]
          else data
        end
      end
    end
  end
end
