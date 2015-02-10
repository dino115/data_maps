module DataMaps
  module Converter
    # Base class for converter
    #
    # @since 0.0.1
    # @abstract
    # @attr_reader @options the given options
    class Base
      attr_reader :options

      # Initializer
      #
      # @param [Hash] options The given options
      def initialize(options = {})
        @options = options
      end

      # The apply method to convert the given data
      #
      # @param [mixed] data
      def apply(data)
        raise NotImplementedError.new('Please implement the apply method for your converter')
      end
    end
  end
end
