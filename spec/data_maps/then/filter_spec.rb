require 'spec_helper'

describe DataMaps::Then::Filter do
  describe '#execute' do
    subject { DataMaps::Then::Filter.new(nil) }

    it 'does nothing with data' do
      data = double(Object)

      expect(subject.execute(data)).to eq data
    end
  end
end
