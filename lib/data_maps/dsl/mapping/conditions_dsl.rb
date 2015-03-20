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

        def when(condition, option)
          self.whens[condition] = option
        end
        alias_method :is, :when

        def then(action, option)
          self.thens[action] = option
        end
        alias_method :so, :then

        # Serialize DSL to an Hash
        def to_h
          data = {
            when: whens,
            then: thens
          }
          data.stringify_keys
        end
      end
    end
  end
end
