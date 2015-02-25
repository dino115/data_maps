require 'spec_helper'

describe DataMaps::When::Empty do
  describe '#execute' do
    describe 'empty true' do
      subject{ DataMaps::When::Empty.new(true) }

      it 'returns true for empty values' do
        expect(subject.execute('')).to be_truthy
      end

      it 'returns false for non empty values' do
        expect(subject.execute('something')).to be_falsey
      end
    end

    describe 'empty false' do
      subject{ DataMaps::When::Empty.new(false) }

      it 'returns false for empty values' do
        expect(subject.execute('')).to be_falsey
      end

      it 'returns true for non empty values' do
        expect(subject.execute('something')).to be_truthy
      end
    end
  end
end
