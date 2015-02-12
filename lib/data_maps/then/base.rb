module DataMaps
  module Then
    extend DataMaps::Concerns::Factory

    # Base class for then's
    #
    # @since 0.0.1
    # @abstract
    class Base
      attr_reader :option

      # Initializer
      #
      # @param [mixed] option The given option(s)
      def initialize(option)
        @option = option
      end

      # The result method which returns a the new data
      #
      # @param [mixed] data
      def result(data)
        raise NotImplementedError.new('Please implement the result method for your then.')
      end
    end
  end
end
