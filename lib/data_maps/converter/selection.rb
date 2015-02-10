module DataMaps
  module Converter
    # Converts selection values
    #
    # @since 0.0.1
    class Selection < Base
      # The apply method to convert the given data
      #
      # @param [mixed] data
      def apply(data)
        @options[data]
      end
    end
  end
end
