module DataMaps
  module Conditions
    # Condition to check for empty data
    #
    # @since 0.0.1
    # @attr_reader @options the given options
    class NotEmpty < Base
      # The check method to evaluate condition on given data
      #
      # @param [mixed] data
      def check(data)
        !data.empty?
      end
    end
  end
end
