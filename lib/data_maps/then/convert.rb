module DataMaps
  module Then
    # A then to convert values
    #
    # @since 0.0.1
    class Convert < Base
      attr_reader :converter

      def after_initialize
        @converter = DataMaps::Converter.create_from_map(@option)
      end

      # The result method which returns the converted data
      #
      # @param [mixed] data
      def result(data)
        converter.each do |converter|
          data = converter.apply(data)
        end

        data
      end
    end
  end
end
