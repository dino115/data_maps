module DataMaps
  module Converter
    # Map values
    #
    # @since 0.0.1
    class Map < Base
      # The after initialize callback
      def after_initialize
        @option = option.with_indifferent_access
      end

      # The execute method to convert the given data
      #
      # @param [mixed] data
      def execute(data)
        case data
          when Array then data.map{ |d| option[d] }
          when Hash then Hash[data.map{ |k,v| [k, option[v]] }]
          else option[data] || data
        end
      end
    end
  end
end
