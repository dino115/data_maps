module DataMaps
  module When
    # Condition to check for empty data
    #
    # @since 0.0.1
    class Empty < Base
      # Check if data is empty? and return true if this equals the option
      #
      # @param [mixed] data
      def execute(data)
        return option unless data.present?
        data.empty? == option
      end
    end
  end
end
