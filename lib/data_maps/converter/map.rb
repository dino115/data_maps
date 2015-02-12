module DataMaps
  module Converter
    # Map values
    #
    # @since 0.0.1
    class Map < Base
      # The apply method to convert the given data
      #
      # @param [mixed] data
      def apply(data)
        case data
          when Array then data.map { |d| @option[d] }
          when Hash then Hash[data.map { |k,v| [k, @option[v]] }]
          else @option[data]
        end
      end
    end
  end
end
