module DataMaps
  module Converter
    # Converts numeric values
    #
    # @since 0.0.1
    class String < Base
      # The execute method to convert the given data into string
      #
      # @param [mixed] data
      def execute(data)
        data.to_s
      end
    end
  end
end
