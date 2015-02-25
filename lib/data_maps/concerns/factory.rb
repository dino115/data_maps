module DataMaps
  module Concerns
    module Factory
      # Factory to create an instance from a class in this module
      #
      # @param [String] name
      # @param [mixed] option
      # @return [Class]
      def factory(name, option)
        name = name.to_s.classify
        klass_name = "#{self.name}::#{name}"
        raise ArgumentError.new("No class '#{klass_name}' exists.") unless self.constants.include?(name.to_sym)

        klass = klass_name.constantize
        klass.new(option)
      end

      # Helper method to create class from a mapping_hash
      #
      # @param [Hash] mapping
      # @return [Array] of factorized classes
      def create_from_map(mapping)
        raise ArgumentError.new("#{self.name} mapping has to be an hash") unless mapping.is_a?(Hash)

        mapping.map do |name, option|
          self.factory(name, option)
        end
      end
    end
  end
end
