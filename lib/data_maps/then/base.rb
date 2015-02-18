module DataMaps
  module Then
    extend DataMaps::Concerns::Factory

    # Helper Method to create then's from a mapping hash
    #
    # @param [Hash] mapping
    #
    # @return [Array] of Then
    def self.create_from_map(mapping)
      raise ArgumentError.new('Then mapping must be an hash') unless mapping.is_a?(Hash)

      mapping.map do |name, option|
        DataMaps::Then.factory(name, option)
      end
    end

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
