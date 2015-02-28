module DataMaps
  module Dsl
    module Mapping
      # DSL method to describe a field
      #
      # @param [String|Symbol] destination
      # @param [Hash] options
      # @param [Block] block
      def field(destination, options = {}, &block)
        dsl = FieldMappingDsl.new(options)
        dsl.configure(&block) if block_given?
        @mapping_hash[destination.to_s] = dsl.to_h
      end

      # Structure to describe a mapping
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
