require 'spec_helper'

describe DataMaps::Converter::Bool do
  describe '#apply' do
    subject { DataMaps::Converter::Bool.new(true) }

    it 'returns true or false' do
      expect([true, false]).to include subject.apply('something')
    end
  end
end
