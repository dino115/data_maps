module DataMaps
  # A mapping statement
  #
  # @since 0.0.1
  # @attr_reader [String] from the source data
  # @attr_reader [String] to the destination data
  # @attr_reader [Array] conditions a array of conditions
  # @attr_reader [Array] converter a array of converter
  class Statement
    attr_reader :from, :to, :conditions, :converter

    # Create statement from a mapping hash
    #
    # @param [Hash] mapping
    # @return [Statement]
    def self.create_from_map(mapping)
      self.new(
        mapping[:from],
        mapping[:to],
        DataMaps::Condition.create_from_map(mapping[:conditions] || []),
        DataMaps::Converter.create_from_map(mapping[:converter] || [])
      )
    end

    # The statement initializer
    #
    # @param [String] from
    # @param [String] to
    # @param [Array] conditions
    # @param [Array] converter
    def initialize(from, to, conditions, converter)
      raise ArgumentError.new('Statement needs a source field') unless from.present?
      raise ArgumentError.new('Conditions must be an array of DataMaps::Condition') unless conditions.is_a?(Array) && conditions.all?{ |c| c.is_a?(DataMaps::Condition) }
      raise ArgumentError.new('Converter must be an array of DataMaps::Converter') unless DataMaps::Converter::Base.valid_collection?(converter)

      @from = from
      @to = to
      @conditions = conditions
      @converter = converter
    end

    # Execute the statement on the given data
    #
    # @param [mixed] data
    # @return [Array] key and value of the result
    def execute(data)
      data = _fetch_from_data(data)

      data = execute_conditions(data)
      data = execute_converter(data)

      [to, data]
    end

    # Execute conditions
    #
    # @param [mixed] data
    # @return [mixed] mutated data
    def execute_conditions(data)
      conditions.reduce(data) do |data, condition|
        condition.execute(data)
      end
    end

    # Apply all converter to the given data
    #
    # @param [mixed] data
    # @return [mixed] mutated data
    def execute_converter(data)
      converter.reduce(data) do |data, converter|
        converter.execute(data)
      end
    end

    private

    # Helper method to fetch the estimated value from data
    #
    # @param [mixed] data
    # @return [mixed] estimated value
    def _fetch_from_data(data)
      case from
        when Array then _fetch_value_from_nested(data)
        when Hash then _fetch_values_from_hash(data)
        else data[from.to_s]
      end
    end

    # Helper method to fetch the value from a nested data structure
    #
    # @param [mixed] data
    # @return [mixed] estimated value
    def _fetch_value_from_nested(data)
      from.reduce(data) { |val, f| val.fetch(f) if val.is_a?(Hash) }
    end

    # Helper method to fetch values from a hash
    #
    # @param [mixed] data
    # @return [mixed] estimated value
    def _fetch_values_from_hash(data)
      Hash[from.map { |k,v| [v.is_a?(TrueClass) ? k.to_s : v.to_s, data[k.to_s]] }]
    end
  end
end
