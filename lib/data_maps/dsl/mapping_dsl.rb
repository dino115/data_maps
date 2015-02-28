module DataMaps
  module Dsl
    module Mapping
      # Define a mapping via a fancy dsl
      #
      # @param [Block] block
      # @return self
      def configure(&block)
        instance_eval &block if block_given?
        self
      end

      # DSL method to describe a field
      #
      # @param [String|Symbol] destination
      # @param [Hash] options
      # @param [Block] block
      def field(destination, options = {}, &block)
        dsl = MappingDsl.new(options)
        dsl.configure(&block) if block_given?
        @mapping_hash[destination.to_s] = dsl.to_h
      end

      # Structure to describe a mapping
      class MappingDsl < Struct.new(:from, :conditions, :converter)
        def initialize(options = {})
          self.from = options[:from]
        end

        # Configure evaluates the given block
        #
        # @param [Block] block
        def configure(&block)
          instance_eval &block
          self
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
