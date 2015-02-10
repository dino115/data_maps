require 'data_maps/statement'

module DataMaps
  # The mapping class which defines a mapping
  #
  # @since 0.0.1
  # attr_reader [Hash] map the compiled mapping
  # attr_reader [Hash] mapping_hash the mapping description
  class Mapping
    attr_reader :map, :mapping_hash

    # Initializer for the Mapping class
    #
    # @param [Hash] mapping_hash
    #
    # @raise [ArgumentError] when the given mapping_hash is not a Hash
    def initialize(mapping_hash)
      raise ArgumentError.new('The mapping_hash must be a Hash') unless mapping_hash.is_a? Hash

      @mapping_hash = mapping_hash.with_indifferent_access

      _generate_mapping
    end

    # Getter to get the statement for a destination_field
    #
    # @param [String|Symbol] destination_field the field name to receive statement for
    # @raise [KeyError] when the destination_field isn't present in map
    def get_statement_for(destination_field)
      raise KeyError.new("The map has no statement for field: #{destination_field}") unless map.has_key?(destination_field)

      @map[destination_field]
    end

    protected

    # Generate an executable mapping from given mapping_hash
    #
    # @private
    def _generate_mapping
      # empty map
      @map = {}

      # iterate over the mapping_hash and initialize mapping for each key
      @mapping_hash.each do |key, value|
        @map[key] = _generate_statement(key, value)
      end
    end

    # Recursive method to generate mapping statements
    #
    # @private
    # @param [String] key The key to
    # @param [mixed] value
    # @return [Hash|Array] with mapper statement
    def _generate_statement(key, value)
      if value.is_a? Array
        value.map do |val|
          _generate_statement(key, val)
        end
      else
        _create_statement(key, value)
      end
    end

    # Helper method to generate a mapping statement
    #
    # @private
    # @param [String] key the destination key
    # @param [Hash|String] value the mapping options
    def _create_statement(key, value)
      options = value.is_a?(Hash) ? value : { source_field: value }

      DataMaps::Statement.new(key, options)
    end
  end
end
