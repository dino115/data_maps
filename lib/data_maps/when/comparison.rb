module DataMaps
  module When
    # Condition to check for greater than
    #
    # @since 0.0.1
    class Gt < Base
      # Check if data is greater than the option
      #
      # @param [mixed] data
      def execute(data)
        data > option
      end
    end

    # Condition to check for greater or equal than
    #
    # @since 0.0.1
    class Gte < Base
      # Check if data is greater or equal than the option
      #
      # @param [mixed] data
      def execute(data)
        data >= option
      end
    end

    # Condition to check for lower than
    #
    # @since 0.0.1
    class Lt < Base
      # Check if data is greater than the option
      #
      # @param [mixed] data
      def execute(data)
        data < option
      end
    end

    # Condition to check for lower or equal than
    #
    # @since 0.0.1
    class Lte < Base
      # Check if data is greater than the option
      #
      # @param [mixed] data
      def execute(data)
        data <= option
      end
    end

    # Condition to check equality
    #
    # @since 0.0.1
    class Eq < Base
      # Check if data equals option
      #
      # @param [mixed] data
      def execute(data)
        data == option
      end
    end

    # Condition to check no equality
    #
    # @since 0.0.1
    class Neq < Base
      # Check if data not equals option
      #
      # @param [mixed] data
      def execute(data)
        data != option
      end
    end

    # Condition to check is in
    #
    # @since 0.0.1
    class In < Base
      # Check if data is part of option
      #
      # @param [mixed] data
      def execute(data)
        option.include?(data)
      end
    end

    # Condition to check is not in
    #
    # @since 0.0.1
    class Nin < Base
      # Check if data is not part of option
      #
      # @param [mixed] data
      def execute(data)
        !option.include?(data)
      end
    end
  end
end
