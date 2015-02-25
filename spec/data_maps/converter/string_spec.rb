require 'spec_helper'

describe DataMaps::Converter::String do
  describe '#execute' do
    subject { DataMaps::Converter::String.new(true) }

    it 'calls to_s on data' do
      data = double(Object)

      expect(data).to receive(:to_s).and_return(String.new)
      expect(subject.execute(data)).to be_a String
    end
  end
end
