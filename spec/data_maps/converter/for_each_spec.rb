require 'spec_helper'

describe DataMaps::Converter::ForEach do
  subject do
    DataMaps::Converter::ForEach.new([
      { apply: :ruby, option: [:fetch, 'name'] },
      { apply: :ruby, option: [:join, "\n"] }
    ])
  end

  describe '#initialize' do
    it 'Creates the converter' do
      expect(subject.converter.length).to eq 2
      expect(subject.converter[0]).to be_a DataMaps::Converter::Ruby
      expect(subject.converter[1]).to be_a DataMaps::Converter::Ruby
    end

    it 'converter has the correct options' do
      expect(subject.converter[0].option).to eq [:fetch, 'name']
      expect(subject.converter[1].option).to eq [:join, "\n"]
    end
  end

  describe '#execute' do
    it 'calls the given converter ordered for each entry in an array' do
      data = %w[ a b ]
      expect(subject.converter[0]).to receive(:execute).with('a').and_return('aa').ordered
      expect(subject.converter[1]).to receive(:execute).with('aa').and_return('aaa').ordered

      expect(subject.converter[0]).to receive(:execute).with('b').and_return('bb').ordered
      expect(subject.converter[1]).to receive(:execute).with('bb').and_return('bbb').ordered

      expect(subject.execute(data)).to eq %w[ aaa bbb ]
    end

    it 'returns the original data for non arrays' do
      data = { x: 1, y: 2 }
      expect(subject.converter[0]).to_not receive(:execute)
      expect(subject.converter[1]).to_not receive(:execute)

      expect(subject.execute(data)).to eq data
    end
  end
end
