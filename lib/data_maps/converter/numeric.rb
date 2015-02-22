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
        raise DataMaps::Errors::InvalidDataError.new("The given data is not a numeric: #{data}") unless is_numeric?(data)

        case option
          when 'Integer' then data.to_i
          when 'Float' then data.to_f
          when Integer then data.to_f.round(option)
          else data
        end
      end

      private

      def is_numeric?(data)
        true if Float(data) rescue false
      end
    end
  end
end
