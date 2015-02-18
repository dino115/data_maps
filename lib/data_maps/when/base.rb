module DataMaps
  module When
    extend DataMaps::Concerns::Factory

    # Helper Method to create when's from a mapping hash
    #
    # @param [Hash] mapping
    #
    # @return [Array] of When
    def self.create_from_map(mapping)
      raise ArgumentError.new('When mapping must be an hash') unless mapping.is_a?(Hash)

      mapping.map do |name, option|
        DataMaps::When.factory(name, option)
      end
    end

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
