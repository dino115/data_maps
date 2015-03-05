module DataMaps
  module Converter
    extend DataMaps::Concerns::Factory

    # Helper method to create converts from a mapping_hash
    #
    # @param [Array] mapping
    # @return [Array] of factorized classes
    def self.create_from_map(mapping)
      raise ArgumentError.new('Converter mapping has to be an array') unless mapping.is_a?(Array)

      mapping.map do |converter|
        converter = { apply: converter } unless converter.is_a? Hash

        raise ArgumentError.new('Converter must be specified with the apply key') unless converter.key?(:apply)
        self.factory(converter[:apply], converter[:option])
      end
    end

    # Base class for converter
    #
    # @since 0.0.1
    # @abstract
    class Base < DataMaps::Executable
    end
  end
end
