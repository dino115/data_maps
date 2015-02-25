require 'spec_helper'

describe DataMaps::Converter::Bool do
  describe '#execute' do
    subject { DataMaps::Converter::Bool.new(true) }

    it 'returns true or false' do
      expect([true, false]).to include subject.execute('something')
    end
  end
end
