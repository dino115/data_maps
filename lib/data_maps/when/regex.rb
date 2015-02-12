module DataMaps
  module When
    # Condition to check for empty data
    #
    # @since 0.0.1
    # @attr_reader @regex the given regex
    class Regex < Base
      attr_reader :regex

      # Initializer
      #
      # @param [Regexp] option the regular expression to match
      def initialize(option)
        @regex = Regexp.new(option)
      end

      # The check method to evaluate condition on given data
      #
      # @param [mixed] data
      def check(data)
        !!@regex.match(data)
      end
    end
  end
end
