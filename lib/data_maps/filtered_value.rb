module DataMaps
  # A filtered value
  #
  # @since 0.0.1
  # @attr_reader [mixed] value
  class FilteredValue
    attr_reader :value

    # Initializer for FilteredValue
    #
    # @param [mixed] value The original value
    def initialize(value)
      @value = value
    end
  end
end
