module DataMaps
  module Dsl
    module Mapping
      # Structure to describe a field mapping
      class ConditionsDsl < Struct.new(:whens, :thens)
        include DataMaps::Concerns::Configurable

        def initialize
          self.whens = {}
          self.thens = {}
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
