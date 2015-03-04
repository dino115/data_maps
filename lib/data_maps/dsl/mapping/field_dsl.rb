module DataMaps
  module Dsl
    module Mapping
      # Structure to describe a field mapping
      class FieldMappingDsl < Struct.new(:from, :conditions, :converter)
        include DataMaps::Concerns::Configurable

        def initialize(options = {})
          self.from = options[:from]
          self.conditions = []
          self.converter = []
        end

        def add_condition(&block)
          dsl = DataMaps::Dsl::Mapping::ConditionsDsl.new
          dsl.configure(&block) if block_given?
          self.conditions << dsl.to_h
        end

        def add_converter(converter, options = nil)
          self.converter << { apply: converter, option: options }
        end

        # Serialize DSL to an Hash
        def to_h
          data = super
          data.stringify_keys
        end
      end
    end
  end
end
