require 'spec_helper'

describe DataMaps::FilteredValue do
  describe 'initialisation' do
    it 'sets value' do
      data = 'something'
      value = DataMaps::FilteredValue.new(data)

      expect(value.value).to be data
    end
  end
end
