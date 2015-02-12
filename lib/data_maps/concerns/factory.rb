module DataMaps
  module Concerns
    module Factory
      # Factory to create an instance from a class in this module
      #
      # @param [String] name
      # @param [mixed] option
      #
      # @return [Class]
      def factory(name, option)
        name = name.classify
        klass_name = "#{self.name}::#{name}"
        raise ArgumentError.new("No class '#{klass_name}' exists.") unless self.constants.include?(name.to_sym)

        klass = klass_name.constantize
        klass.new(option)
      end
    end
  end
end
