module DataMaps
  module Converter
    # Converts numeric values
    #
    # @since 0.0.1
    class Numeric < Base
      # The apply method to convert the given data
      #
      # @param [mixed] data
      def apply(data)
        raise DataMaps::Errors::InvalidData.new("The given data is not a numeric: #{data}") unless data.is_a?(Numeric) || (data.is_a?(String) && is_numeric_string(data))

        if @options.is_a? Hash
          data = data.to_f
          data.round(@options[:precision]) if @options.has_key? :precision
        else
          data.to_i
        end
      end

      private

      def is_numeric_string(data)
        true if Float(data) rescue false
      end
    end
  end
end
