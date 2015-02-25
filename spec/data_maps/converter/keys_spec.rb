require 'spec_helper'

describe DataMaps::Converter::Keys do
  describe '#execute' do
    subject { DataMaps::Converter::Keys.new({ a: 'x', b: 'y', c: 'z' }) }

    it 'converts the keys' do
      expect(
        subject.execute({ a: 1, b: 2, c: 3 })
      ).to eq({ 'x' => 1, 'y' => 2, 'z' => 3 })
    end

    it 'does nothing with keys that doesn\'t exist in mapping' do
      expect(
        subject.execute({ d: 4, e: 5, f: 6 })
      ).to eq({ d: 4, e: 5, f: 6 })
    end

    it 'does nothing with data when data isn\'t a hash' do
      expect(
        subject.execute('something')
      ).to eq 'something'
    end
  end
end
