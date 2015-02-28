module DataMaps
  module Concerns
    module Configurable
      # Concern to allow configuration via instance evaluation
      #
      # @param [Block] block
      # @return self
      def configure(&block)
        instance_eval &block if block_given?
        self
      end
    end
  end
end
