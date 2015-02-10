module DataMaps
  module Conditions
    # Condition to check for empty data
    #
    # @since 0.0.1
    # @attr_reader @regex the given regex
    class Regex < Base
      attr_reader :regex

      # Initializer
      #
      # @param [String] regex the regular expression to match
      def initialize(regex)
        @regex = Regexp.new(regex)
      end

      # The check method to evaluate condition on given data
      #
      # @param [mixed] data
      def check(data)
        @regex.match(data).present?
      end
    end
  end
end
