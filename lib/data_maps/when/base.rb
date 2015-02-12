module DataMaps
  module When
    extend DataMaps::Concerns::Factory

    # Base class for when's
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
      end

      # The check method to evaluate condition on given data
      #
      # @param [mixed] data
      def check(data)
        raise NotImplementedError.new('Please implement the check method for your when.')
      end
    end
  end
end
