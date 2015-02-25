module DataMaps
  module Then
    extend DataMaps::Concerns::Factory

    # Base class for then's
    #
    # @since 0.0.1
    # @abstract
    # @attr_reader @option the given option
    class Base
      attr_reader :option

      # Initializer
      #
      # @param [mixed] option The given option(s)
      def initialize(option)
        @option = option

        self.after_initialize if self.respond_to? :after_initialize
      end

      # The result method which returns the new data
      #
      # @param [mixed] data
      # @raise NotImplementedError
      def result(data)
        raise NotImplementedError.new('Please implement the result method for your then.')
      end
    end
  end
end
