module DataMaps
  module When
    # Condition to check for an regular expression
    #
    # @since 0.0.1
    # @attr_reader @regex the given regex
    class Regex < Base
      attr_reader :regex

      # After initialize callback
      def after_initialize
        @regex = Regexp.new(option)
      end

      # The check method to evaluate condition on given data
      #
      # @param [mixed] data
      def execute(data)
        !!@regex.match(data)
      end
    end
  end
end
