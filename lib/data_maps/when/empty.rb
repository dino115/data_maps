module DataMaps
  module When
    # Condition to check for empty data
    #
    # @since 0.0.1
    class Empty < Base
      # Check if data is empty? and return true if this equals the option
      #
      # @param [mixed] data
      def check(data)
        data.empty? == option
      end
    end
  end
end
