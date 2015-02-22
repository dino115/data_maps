require 'spec_helper'

describe DataMaps::Then::Convert do
  subject { DataMaps::Then::Convert.new({ map: { a: 'x', b: 'y' }, ruby: [:join, ','] }) }

  describe 'initialization' do
    it 'Creates the converter' do
      expect(subject.converter.length).to eq 2
      expect(subject.converter[0]).to be_a DataMaps::Converter::Map
      expect(subject.converter[1]).to be_a DataMaps::Converter::Ruby
    end

    it 'converter has the correct options' do
      expect(subject.converter[0].option).to eq({ 'a' => 'x', 'b' => 'y' })
      expect(subject.converter[1].option).to eq [:join, ',']
    end
  end

  describe '#result' do
    it 'calls the given converter ordered' do
      data = %w[ a b ]
      expect(subject.converter[0]).to receive(:apply).with(data).and_return(data).ordered
      expect(subject.converter[1]).to receive(:apply).with(data).and_return(data).ordered

      expect(subject.result(data)).to eq data
    end
  end
end
