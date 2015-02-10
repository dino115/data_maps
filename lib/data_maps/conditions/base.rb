module DataMaps
  module Conditions
    # Base class for conditions
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

      # The check method to evaluate condition on given data
      #
      # @param [mixed] data
      def check(data)
        raise NotImplementedError.new('Please implement the check method for your condition')
      end
    end
  end
end
