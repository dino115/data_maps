require 'spec_helper'

describe DataMaps::Statement do
  describe '::create_from_map' do
    it 'creates a new Statement' do
      mapping = { from: 'a', to: 'b' }

      expect(DataMaps::Condition).to receive(:create_from_map).with([]).and_return([])
      expect(DataMaps::Converter).to receive(:create_from_map).with({}).and_return([])

      expect(DataMaps::Statement).to receive(:new).with('a', 'b', [], [])

      DataMaps::Statement.create_from_map(mapping)
    end
  end

  describe 'arguments' do
    it 'cant\'t be initialized without a from param' do
      expect{ DataMaps::Statement.new(nil, nil, [], []) }.to raise_error ArgumentError
    end

    it 'can\'t be initialized without conditions' do
      expect{ DataMaps::Statement.new('from', 'to', nil, []) }.to raise_error ArgumentError
    end

    it 'can\'t be initialized with wrong conditions' do
      expect{ DataMaps::Statement.new('from', 'to', ['a', 5], []) }.to raise_error ArgumentError
    end

    it 'can\'t be initialized without converter' do
      expect{ DataMaps::Statement.new('from', 'to', [], nil) }.to raise_error ArgumentError
    end

    it 'can\'t be initialized with wrong converter' do
      expect{ DataMaps::Statement.new('from', 'to', [], ['b', 6]) }.to raise_error ArgumentError
    end
  end
end
