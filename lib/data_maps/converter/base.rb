module DataMaps
  module Converter
    extend DataMaps::Concerns::Factory

    # Helper method to create converter from a mapping_hash
    #
    # @param [Hash] mapping
    #
    # @return [Array] of Converter
    def self.create_from_map(mapping)
      raise ArgumentError.new('Converter mapping has to be an hash') unless mapping.is_a?(Hash)

      mapping.map do |name, option|
        DataMaps::Converter.factory(name, option)
      end
    end

    # Base class for converter
    #
    # @since 0.0.1
    # @abstract
    # @attr_reader @options the given options
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
