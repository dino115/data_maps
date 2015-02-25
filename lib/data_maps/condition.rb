module DataMaps
  # A condition
  #
  # @since 0.0.1
  # @attr_reader [Array] whens
  # @attr_reader [Array] thens
  class Condition
    attr_reader :whens, :thens

    # Helper method to create conditions from a mapping
    #
    # @param [Array] mapping
    #
    # @return [Array] of Condition
    def self.create_from_map(mapping)
      raise ArgumentError.new('Conditions mapping has to be an array') unless mapping.is_a?(Array)

      mapping.map do |condition|
        self.new(
          DataMaps::When.create_from_map(condition[:when]),
          DataMaps::Then.create_from_map(condition[:then])
        )
      end
    end

    # Initializer for a Condition
    #
    # @param [Array] whens an array of when's
    # @param [Array] thens an array of then's
    def initialize(whens, thens)
      raise ArgumentError.new('Whens must be an array of whens') unless whens.is_a?(Array) && whens.all?{ |w| w.is_a?(DataMaps::When::Base) }
      raise ArgumentError.new('Thens mus be an array of thens') unless thens.is_a?(Array) && thens.all?{ |t| t.is_a?(DataMaps::Then::Base) }

      @whens = whens
      @thens = thens
    end

    # Helper method to indicate if this condition can break execution
    #
    # @return [Bool]
    def can_break?
      thens.any?{ |t| t.is_a?(DataMaps::Then::Filter) }
    end

    # Execute this condition with given data
    #
    # @param [mixed] data The given data
    # @return [mixed] data The original or modified data for the next step
    def execute(data)
      if check(data)
        if can_break?
          DataMaps::FilteredValue.new(data)
        else
          result(data)
        end
      else
        data
      end
    end

    # Check all whens on data
    #
    # @param [mixed] data The given data
    # @return [mixed] data The original or modified data for the next step
    def check(data)
      whens.all? { |w| w.execute data }
    end

    # Apply the thens on data
    #
    # @param [mixed] data The given data
    # @return [mixed] data The original or modified data for the next step
    def result(data)
      thens.each do |t|
        data = t.execute(data)
      end

      data
    end
  end
end
