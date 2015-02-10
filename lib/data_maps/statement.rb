require 'data_maps/conditions/base'
require 'data_maps/conditions/not_empty'
require 'data_maps/conditions/regex'

require 'data_maps/converter/base'
require 'data_maps/converter/numeric'
require 'data_maps/converter/selection'

module DataMaps
  # A mapping statement
  #
  # @since 0.0.1
  # @attr_reader [String] destination_field the field name in the destination data
  # @attr_reader [String] source_field the field name of the source data
  # @attr_reader [Array] converter converter to apply to the data
  # @attr_reader [Array] conditions conditions to match the value
  class Statement
    attr_reader :destination_field, :source_field, :converter, :conditions

    def initialize(key, options = {})
      @destination_field = key
      @converter = []
      @conditions = []

      raise ArgumentError.new('Statement needs a source field') unless options.key?(:source_field)
      @source_field = options[:source_field]

      _build_converter(options[:converter]) if options.key?(:converter)
      _build_conditions(options[:conditions]) if options.key?(:conditions)
    end

    private

    # Helper method to create converter classes
    #
    # @private
    # @param [String|Hash] converter the converter descriptions
    def _build_converter(converter)
      if converter.is_a? String
        klass = "DataMaps::Converter::#{converter.classify}".constantize
        @converter << klass.new
      elsif converter.is_a? Hash
        converter.each do |converter_klass, options|
          klass = "DataMaps::Converter::#{converter_klass.classify}".constantize
          @converter << klass.new(options)
        end
      else
        raise ArgumentError.new("Undefined converter definition for property: #{key}")
      end
    end

    # Helper method to create condition classes
    #
    # @private
    # @param [String|Hash] conditions the conditions to check
    def _build_conditions(conditions)
      if conditions.is_a? String
        klass = "DataMaps::Conditions::#{conditions.classify}".constantize
        @conditions << klass.new
      elsif conditions.is_a? Hash
        conditions.each do |condition, options|
          klass = "DataMaps::Conditions::#{condition.classify}".constantize
          @conditions << klass.new(options)
        end
      else
        raise ArgumentError.new("Undefined condition definition for property: #{key}")
      end
    end
  end
end
