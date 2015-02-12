module DataMaps
  module Converter
    # Ruby method converter
    #
    # @since 0.0.1
    class Ruby < Base
      # Initializer
      #
      # @param [Hash] option The given options
      def initialize(option)
        @option = Array(option)
      end

      # The apply method to convert the given data
      #
      # @param [mixed] data
      def apply(data)
        data.respond_to?(option.first) ? data.send(*option) : data
      end
    end
  end
end
