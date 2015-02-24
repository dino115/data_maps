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

  describe '#execute' do
    it 'slices source_data from a single field' do
      statement = DataMaps::Statement.new('from', 'to', [], [])
      data = { 'from' => 'some value' }

      expect(statement.execute(data)).to eq ['to', 'some value']
    end

    it 'slices source_data from an array of fields' do
      statement = DataMaps::Statement.new(%w[ from1 from2 ], 'to', [], [])
      data = { 'from1' => 'first value', 'from2' => 'second value', 'from3' => 'third value' }

      expect(statement.execute(data)).to eq ['to', { 'from1' => 'first value', 'from2' => 'second value' }]
    end

    it 'calls execute_conditions with data' do
      statement = DataMaps::Statement.new('from', 'to', [], [])
      data = { 'from' => 'some value' }

      expect(statement).to receive(:execute_conditions).with('some value').and_call_original
      expect(statement.execute(data)).to eq ['to', 'some value']
    end

    it 'calls execute_converter with mutated data' do
      statement = DataMaps::Statement.new('from', 'to', [], [])
      data = { 'from' => 'some value' }

      expect(statement).to receive(:execute_conditions).ordered.with('some value').and_return('some mutated value')
      expect(statement).to receive(:execute_converter).ordered.with('some mutated value').and_return('some double mutated value')

      expect(statement.execute(data)).to eq ['to', 'some double mutated value']
    end
  end

  describe '#execute_conditions' do
    it 'execute all conditions ordered and with mutated data' do
      statement = DataMaps::Statement.new('from', 'to', [DataMaps::Condition.new([], []), DataMaps::Condition.new([], [])], [])

      expect(statement.conditions[0]).to receive(:execute).ordered.with('some value').and_return('mutated value')
      expect(statement.conditions[1]).to receive(:execute).ordered.with('mutated value').and_return('some mutated value')

      expect(statement.execute_conditions('some value')).to eq 'some mutated value'
    end
  end

  describe '#execute_converter' do
    it 'execute all converter ordered and with mutated data' do
      statement = DataMaps::Statement.new('from', 'to', [], [DataMaps::Converter::Base.new(nil), DataMaps::Converter::Base.new(nil)])

      expect(statement.converter[0]).to receive(:apply).ordered.with('some value').and_return('mutated value')
      expect(statement.converter[1]).to receive(:apply).ordered.with('mutated value').and_return('some mutated value')

      expect(statement.execute_converter('some value')).to eq 'some mutated value'
    end
  end
end
