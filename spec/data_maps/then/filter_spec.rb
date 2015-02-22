require 'spec_helper'

describe DataMaps::Then::Filter do
  describe '#result' do
    subject { DataMaps::Then::Filter.new(nil) }

    it 'does nothing with data' do
      data = double(Object)

      expect(subject.result(data)).to eq data
    end
  end
end
