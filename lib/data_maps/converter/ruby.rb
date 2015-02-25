module DataMaps
  module Converter
    # Ruby method converter
    #
    # @since 0.0.1
    class Ruby < Base
      # After initialize callback
      def after_initialize
        @option = Array(option)
      end

      # The execute method to convert the given data
      #
      # @param [mixed] data
      def execute(data)
        data.respond_to?(option.first) ? data.send(*option) : data
      end
    end
  end
end
