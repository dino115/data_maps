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
    # @param [Hash] map
    #
    # @return [Statement]
    def self.build_from_map(map)
      self.new(
        map[:from],
        map[:to],
        _create_conditions_from_map(map[:conditions] || []),
        _create_converter_from_map(map[:converter] || {})
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
      raise ArgumentError.new('Converter must be an array of DataMaps::Converter') unless converter.is_a?(Array) && converter.all?{ |c| c.is_a?(DataMaps::Converter) }

      @from = from
      @to = to
      @conditions = conditions
      @converter = converter
    end

    private

    # Helper method to create conditions from a mapping_hash
    #
    # @param [Array] conditions_map
    #
    # @return [Array] of Condition
    def self._create_conditions_from_map(conditions_map)
      raise ArgumentError.new('conditions has to be an array') unless conditions_map.is_a?(Array)

      conditions_map.map do |condition|
        DataMaps::Condition.build_from_map(condition)
      end
    end

    # Helper method to create converter from a mapping_hash
    #
    # @param [Hash] converter_map
    #
    # @return [Array] of Converter
    def self._create_converter_from_map(converter_map)
      raise ArgumentError.new('converter has to be an hash') unless converter_map.is_a?(Hash)

      converter_map.map do |name, option|
        DataMaps::Converter.factory(name, option)
      end
    end
  end
end
