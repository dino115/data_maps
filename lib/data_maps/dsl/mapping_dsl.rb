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
    end
  end
end
