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
    #
    # @return [Statement]
    def self.create_from_map(mapping)
      self.new(
        mapping[:from],
        mapping[:to],
        DataMaps::Condition.create_from_map(mapping[:conditions] || []),
        DataMaps::Converter.create_from_map(mapping[:converter] || {})
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
      raise ArgumentError.new('Converter must be an array of DataMaps::Converter') unless converter.is_a?(Array) && converter.all?{ |c| c.is_a?(DataMaps::Converter::Base) }

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
      source_data = from.is_a?(Array) ? Hash[from.map{ |f| [f, data[f.to_s]] }] : data[from.to_s]

      data = execute_conditions(source_data)
      data = execute_converter(data)

      [to, data]
    end

    # Execute conditions
    #
    # @param [mixed] data
    # @return [mixed] mutated data
    def execute_conditions(data)
      conditions.each do |condition|
        data = condition.execute(data)
      end

      data
    end

    # Execute converter
    #
    # @param [mixed] data
    # @return [mixed] mutated data
    def execute_converter(data)
      converter.each do |converter|
        data = converter.apply(data)
      end

      data
    end
  end
end
