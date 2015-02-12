# Require gem stuff
require 'active_support/all'

# Require all project files
Dir.glob(File.join(__dir__, 'data_maps', '{concerns,converter,errors,then,when}', '*.rb'), &method(:require))
Dir.glob(File.join(__dir__, 'data_maps', '*.rb'), &method(:require))

module DataMaps
  # Nothing to do here :)
end
