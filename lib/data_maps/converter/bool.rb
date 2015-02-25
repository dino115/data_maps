module DataMaps
  module Converter
    # Converts numeric values
    #
    # @since 0.0.1
    class Bool < Base
      # The execute method to convert the given data into string
      #
      # @param [mixed] data
      def execute(data)
        !!data
      end
    end
  end
end
