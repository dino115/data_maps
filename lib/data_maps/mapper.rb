module DataMaps
  # The base mapper class which handles all mapping logic
  #
  # @since 0.0.1
  # @attr [Mapping] mapping
  class Mapper
    # Attribute Accessors
    attr_accessor :mapping

    # Initializer for the Mapper class
    #
    # @param [Mapping] mapping the mapping which will used to map data
    # @raise [ArgumentError] when mapping is not a correct mapping object
    def initialize(mapping)
      raise ArgumentError.new('The mapping should be a DataMaps::Mapping::Base') unless mapping.is_a? DataMaps::Mapping

      @mapping = mapping
    end
  end
end
