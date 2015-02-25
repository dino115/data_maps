module DataMaps
  # Base class for executables (converter, when, then)
  #
  # @since 0.0.1
  # @abstract
  # @attr_reader @option the given option
  class Executable
    attr_reader :option

    # Initializer
    #
    # @param [mixed] option The given options
    def initialize(option)
      @option = option

      self.after_initialize if self.respond_to? :after_initialize
    end

    # The execute method to apply checks or mutations on the given data
    #
    # @param [mixed] data
    def execute(data)
      raise NotImplementedError.new("Please implement the execute method for your #{self.class.name}")
    end
  end
end
