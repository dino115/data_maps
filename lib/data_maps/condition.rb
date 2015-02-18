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

    def initialize(whens, thens)
      raise ArgumentError.new('Whens must be an array of whens') unless whens.is_a?(Array) && whens.all?{ |w| w.is_a?(DataMaps::When::Base) }
      raise ArgumentError.new('Thens mus be an array of thens') unless thens.is_a?(Array) && thens.all?{ |t| t.is_a?(DataMaps::Then::Base) }

      @whens = whens
      @thens = thens
    end

    def can_break?
      @thens.any?{ |t| t.is_a?(DataMaps::Then::Filter) }
    end

  end
end
