require 'spec_helper'

describe DataMaps::Condition do
  describe '::create_from_map' do
    it 'creates a new Condition' do
      mapping = [
        { when: { empty: true }, then: { filter: true } }
      ]

      expect(DataMaps::When).to receive(:create_from_map).with(mapping.first[:when]).and_call_original
      expect(DataMaps::Then).to receive(:create_from_map).with(mapping.first[:then]).and_call_original

      expect(DataMaps::Condition).to receive(:new).with([DataMaps::When::Empty], [DataMaps::Then::Filter])

      DataMaps::Condition.create_from_map(mapping)
    end
  end

  describe 'arguments' do
    it 'can\'t be initialized without whens' do
      expect{ DataMaps::Condition.new(nil, []) }.to raise_error ArgumentError
    end

    it 'can\'t be initialized with wrong whens' do
      expect{ DataMaps::Condition.new(['a', 5], []) }.to raise_error ArgumentError
    end

    it 'can\'t be initialized without thens' do
      expect{ DataMaps::Condition.new([], nil) }.to raise_error ArgumentError
    end

    it 'can\'t be initialized with wrong thens' do
      expect{ DataMaps::Condition.new([], ['b', 6]) }.to raise_error ArgumentError
    end
  end

  describe '#can_break?' do
    it 'returns false' do
      condition = DataMaps::Condition.new([], [])
      expect(condition.can_break?).to be_falsey
    end

    it 'returns true if there is a Then::Filter present' do
      condition = DataMaps::Condition.new([], [DataMaps::Then::Filter.new(true)])
      expect(condition.can_break?).to be_truthy
    end
  end
end
