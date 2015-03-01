module DataMaps
  module Dsl
    module Mapping
      # Structure to describe a field mapping
      class FieldMappingDsl < Struct.new(:from, :conditions, :converter)
        include DataMaps::Concerns::Configurable

        def initialize(options = {})
          self.from = options[:from]
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
