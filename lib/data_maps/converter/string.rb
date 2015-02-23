module DataMaps
  module Converter
    # Converts numeric values
    #
    # @since 0.0.1
    class String < Base
      # The apply method to convert the given data into string
      #
      # @param [mixed] data
      def apply(data)
        data.to_s
      end
    end
  end
end
