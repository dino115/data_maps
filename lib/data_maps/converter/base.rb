module DataMaps
  module Converter
    extend DataMaps::Concerns::Factory

    # Base class for converter
    #
    # @since 0.0.1
    # @abstract
    # @attr_reader @option the given option
    class Base
      attr_reader :option

      # Initializer
      #
      # @param [mixed] option The given options
      def initialize(option)
        @option = option

        self.after_initialize if self.respond_to? :after_initialize
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
