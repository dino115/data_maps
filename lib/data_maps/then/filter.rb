module DataMaps
  module Then
    # A then to filter values
    #
    # @since 0.0.1
    class Filter < Base
      # Return the original data
      #
      # @param [mixed] data
      # @return [mixed] data
      def execute(data)
        data
      end
    end
  end
end
