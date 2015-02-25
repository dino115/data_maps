require 'spec_helper'

describe DataMaps::Converter::Ruby do
  describe '#execute' do
    subject { DataMaps::Converter::Ruby.new([:my_method, 'option1', 'option2']) }

    it 'applies the given method on the data' do
      data = double(Object)

      expect(data).to receive(:my_method).with('option1', 'option2')

      subject.execute(data)
    end
  end
end
