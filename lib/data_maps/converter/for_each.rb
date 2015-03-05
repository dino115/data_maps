module DataMaps
  module Converter
    # Apply Converter for each entry
    #
    # @since 0.3.3
    class ForEach < Base
      attr_reader :converter

      # The after initialize callback
      def after_initialize
        @converter = DataMaps::Converter.create_from_map(option)
      end

      # The execute converters for each value
      #
      # @param [mixed] data
      # @return [mixed] mutated data
      def execute(data)
        case data
          when Array
            data.map do |value|
              converter.reduce(value) do |value, converter|
                converter.execute(value)
              end
            end
          else data
        end
      end
    end
  end
end
