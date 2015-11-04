require 'spec_helper'

describe DataMaps::Statement do
  describe '::create_from_map' do
    it 'creates a new Statement' do
      mapping = { from: 'a', to: 'b' }

      expect(DataMaps::Condition).to receive(:create_from_map).with([]).and_return([])
      expect(DataMaps::Converter).to receive(:create_from_map).with([]).and_return([])

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
    it 'slices the source data from a single field' do
      statement = DataMaps::Statement.new('from', 'to', [], [])
      data = { 'from' => 'some value' }

      expect(statement.execute(data)).to eq ['to', 'some value']
    end

    it 'slices source data from a field chain (array of fields)' do
      statement = DataMaps::Statement.new(%w[ from1 from2 ], 'to', [], [])
      data = { 'from1' => { 'from2' => 'my value', 'from3' => 'my second value' }, 'from4' => 'another value' }

      expect(statement.execute(data)).to eq ['to', 'my value']
    end

    it 'slices a nil value from a field chain (array of fields) where some fields missing' do
      statement = DataMaps::Statement.new(%w[ from from2 ], 'to', [], [])
      data = { 'from1' => { 'from2' => 'my value', 'from3' => 'my second value' }, 'from4' => 'another value' }

      expect(statement.execute(data)).to eq ['to', nil]
    end

    it 'slices source data from a collection of fields (hash of fields)' do
      statement = DataMaps::Statement.new({ from1: true, from2: true }, 'to', [], [])
      data = { 'from1' => 'first value', 'from2' => 'second value', 'from3' => 'third value' }

      expect(statement.execute(data)).to eq ['to', { 'from1' => 'first value', 'from2' => 'second value' }]
    end

    it 'slices source data from a collection of fields with mapping (hash of fields)' do
      statement = DataMaps::Statement.new({ from1: 'field1', from2: 'field2' }, 'to', [], [])
      data = { 'from1' => 'first value', 'from2' => 'second value', 'from3' => 'third value' }

      expect(statement.execute(data)).to eq ['to', { 'field1' => 'first value', 'field2' => 'second value' }]
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

    it 'doesn\'t call execute_converter if condition returns a FilteredValue' do
      statement = DataMaps::Statement.new('from', 'to', [], [])
      data = { 'from' => 'some value' }
      filtered_value = DataMaps::FilteredValue.new('some value')

      expect(statement).to receive(:execute_conditions).with('some value').and_return(filtered_value)
      expect(statement).not_to receive(:execute_converter)

      expect(statement.execute(data)).to eq ['to', filtered_value]
    end
  end

  describe '#execute_conditions' do
    it 'execute all conditions ordered and with mutated data' do
      statement = DataMaps::Statement.new('from', 'to', [DataMaps::Condition.new([], []), DataMaps::Condition.new([], [])], [])

      expect(statement.conditions[0]).to receive(:execute).ordered.with('some value').and_return('mutated value')
      expect(statement.conditions[1]).to receive(:execute).ordered.with('mutated value').and_return('some mutated value')

      expect(statement.execute_conditions('some value')).to eq 'some mutated value'
    end

    it 'doesn\'t execute the next converter if the first one returns a filtered value' do
      statement = DataMaps::Statement.new('from', 'to', [DataMaps::Condition.new([], []), DataMaps::Condition.new([], [])], [])
      filtered_value = DataMaps::FilteredValue.new('some value')

      expect(statement.conditions[0]).to receive(:execute).with('some value').and_return(filtered_value)
      expect(statement.conditions[1]).not_to receive(:execute)

      expect(statement.execute_conditions('some value')).to eq filtered_value
    end
  end

  describe '#execute_converter' do
    it 'execute all converter ordered and with mutated data' do
      statement = DataMaps::Statement.new('from', 'to', [], [DataMaps::Converter::Base.new(nil), DataMaps::Converter::Base.new(nil)])

      expect(statement.converter[0]).to receive(:execute).ordered.with('some value').and_return('mutated value')
      expect(statement.converter[1]).to receive(:execute).ordered.with('mutated value').and_return('some mutated value')

      expect(statement.execute_converter('some value')).to eq 'some mutated value'
    end
  end
end
