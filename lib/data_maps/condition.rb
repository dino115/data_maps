module DataMaps
  # A condition
  #
  # @since 0.0.1
  # @attr_reader [Array] whens
  # @attr_reader [Array] thens
  class Condition
    attr_reader :whens, :thens

    def self.build_from_map(map)
      self.new(
        _create_whens_from_map(map[:when]),
        _create_thens_from_map(map[:then]),
      )
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

    private

    def self._create_whens_from_map(when_map)
      raise ArgumentError.new('Condition: when must be an hash') unless when_map.is_a?(Hash)

      when_map.map do |name, option|
        DataMaps::When.factory(name, option)
      end
    end

    def self._create_thens_from_map(then_map)
      raise ArgumentError.new('Condition: then must be an hash') unless then_map.is_a?(Hash)

      then_map.map do |name, option|
        DataMaps::Then.factory(name, option)
      end
    end
  end
end
