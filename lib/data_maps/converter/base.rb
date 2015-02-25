module DataMaps
  module Converter
    extend DataMaps::Concerns::Factory

    # Base class for converter
    #
    # @since 0.0.1
    # @abstract
    class Base < DataMaps::Executable
    end
  end
end
