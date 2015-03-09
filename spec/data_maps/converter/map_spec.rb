require 'spec_helper'

describe DataMaps::Converter::Map do
  describe '#execute' do
    subject { DataMaps::Converter::Map.new({ a: 'x', b: 'y', c: 'z' }) }

    describe 'for arrays' do
      it 'converts an array of data' do
        expect(
          subject.execute(%w[ a b c ])
        ).to eq %w[ x y z ]
      end

      it 'returns nil when a value doesn\'t exists in map' do
        expect(
          subject.execute(%w[ a b c d ])
        ).to eq [ 'x', 'y', 'z', nil ]
      end
    end

    describe 'for hashes' do
      it 'converts values in a data hash' do
        expect(
          subject.execute({ x: 'a', y: 'b', z: 'c' })
        ).to eq({ x: 'x', y: 'y', z: 'z' })
      end

      it 'returns nil when a value doesn\'t exists in map' do
        expect(
          subject.execute({ x: 'a', y: 'b', z: 'c', w: 'd' })
        ).to eq({ x: 'x', y: 'y', z: 'z', w: nil })
      end
    end

    describe 'for scalar values' do
      it 'converts the value' do
        expect(subject.execute('a')).to eq 'x'
      end

      it 'returns original value when value doesn\'t exists in map' do
        expect(subject.execute('d')).to eq 'd'
      end
    end
  end
end
