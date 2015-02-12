module DataMaps
  # The mapping class which defines a mapping
  #
  # @since 0.0.1
  # attr_reader [Hash] mapping the compiled mapping
  # attr_reader [Hash] mapping_hash the mapping description
  class Mapping
    attr_reader :mapping, :mapping_hash

    # Initializer for the Mapping class
    #
    # @param [Hash] mapping_hash
    #
    # @raise [ArgumentError] when the given mapping_hash is not a Hash
    def initialize(mapping_hash = {})
      raise ArgumentError.new('The mapping_hash must be a Hash') unless mapping_hash.is_a? Hash

      @mapping = {}
      @mapping_hash = mapping_hash.with_indifferent_access
    end

    # Compile the mapping statements, this will lazily called on first use
    #
    def compile
      unless @_compiled
        # iterate over the mapping_hash and initialize mapping for each key
        @mapping_hash.each do |destination, map|
          @mapping[destination] = _create_statement(destination, map)
        end

        @_compiled = true
      end
    end

    # Validate the mapping statements, this is a compiling without save the compiled mapping
    def valid?
      true if validate rescue false
    end

    def validate
      @mapping_hash.each &method(:_create_statement)
    end

    # Getter to get the statement for a destination_field
    #
    # @param [String|Symbol] destination the field name to receive statement for
    # @raise [KeyError] when the destination_field isn't present in map
    def get_statement_for(destination)
      compile

      raise KeyError.new("The map has no statement for field: #{destination}") unless mapping.has_key?(destination)

      @mapping[destination]
    end

    # Allow iterations over all statements
    #
    # @param [Block] &block the block to execute for each map statement
    #
    # @return [Enumerator] enum return the enumerator if no block given
    def each_statement
      compile

      return enum_for(:each_statement) unless block_given? # return Enumerator

      @mapping.each do |destination, statement|
        yield destination, statement
      end
    end

    protected

    # Create a mapping statement
    #
    # @protected
    #
    # @param [String] destination The destination field
    # @param [String|Hash] map
    #
    # @return [Statement] executable statement
    def _create_statement(destination, map)
      map = { from: map } if map.is_a? String
      map[:to] = destination
      DataMaps::Statement.build_from_map(map)
    end
  end
end
