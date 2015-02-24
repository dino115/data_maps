require 'spec_helper'

describe DataMaps::Mapping do
  let(:simple_mapping_hash) do
    {
      'destination1' => 'source1',
      'destination2' => 'source2'
    }
  end

  let(:conditional_mapping_hash) do
    {
      'destination1' => {
        from: 'source1',
        conditions: [
          { when: { empty: true }, then: { filter: true } },
          { when: { regex: /[a-z]/ }, then: { convert: { ruby: :upcase } } },
        ]
      }
    }
  end

  let(:converter_mapping_hash) do
    {
      'destination2' => {
        from: %w[ source2 source3 ],
        converter: {
          ruby: [:join, ', '],
        }
      }
    }
  end

  let(:complex_mapping_hash) do
    conditional_mapping_hash.merge converter_mapping_hash
  end

  let(:invalid_mapping_hash) do
    {
      'destination3' => {
        from: 'source3',
        condition: { when: 'this', then: 'that' },
        converter: 'something invalid'
      }
    }
  end

  it 'cant\t be initialized without a valid mapping_hash' do
    expect{ DataMaps::Mapping.new('something') }.to raise_error ArgumentError
  end

  describe 'compile' do
    describe 'lazy compilation' do
      subject{ DataMaps::Mapping.new(simple_mapping_hash) }

      it 'compiles nothing if mapping is initialized' do
        expect(subject.mapping).to be_empty
      end

      it 'compiles if calling get_statement_for' do
        expect{ subject.get_statement_for('destination1') }.to change{ subject.mapping.length }.from(0).to(2)
      end

      it 'compiles if calling each_statement' do
        expect{ subject.each_statement { |d,s| } }.to change{ subject.mapping.length }.from(0).to(2)
      end
    end

    # Test mapping generation of a simple destination => source mapping without any conditions or converter
    describe 'simple mapping hash' do
      subject{ DataMaps::Mapping.new(simple_mapping_hash) }

      it 'has correct destination key' do
        expect{ subject.get_statement_for('destination1') }.not_to raise_error
      end
      it 'is a MappingStatement' do
        expect(subject.get_statement_for('destination1')).to be_a DataMaps::Statement
      end
      it 'has the correct statement options' do
        statement = subject.get_statement_for('destination1')

        expect(statement.from).to eq 'source1'
        expect(statement.to).to eq 'destination1'
        expect(statement.conditions).to be_a Array
        expect(statement.conditions).to be_empty
        expect(statement.converter).to be_a Array
        expect(statement.converter).to be_empty
      end
    end

    # Test mapping generation of a mapping hash with conditions
    describe 'conditional mapping hash' do
      subject{ DataMaps::Mapping.new(conditional_mapping_hash) }

      it 'has correct destination key' do
        expect{ subject.get_statement_for('destination1') }.not_to raise_error
      end
      it 'is a MappingStatement' do
        expect(subject.get_statement_for('destination1')).to be_a DataMaps::Statement
      end
      it 'has the correct statement options' do
        statement = subject.get_statement_for('destination1')

        expect(statement.from).to eq 'source1'
        expect(statement.to).to eq 'destination1'
        expect(statement.conditions).to be_a Array
        expect(statement.conditions.length).to eq 2
        expect(statement.conditions.all?{ |c| c.is_a?(DataMaps::Condition) }).to be_truthy
        expect(statement.converter).to be_a Array
        expect(statement.converter).to be_empty
      end
    end

    # Test mapping generation of a mapping hash with converter
    describe 'conditional mapping hash' do
      subject{ DataMaps::Mapping.new(converter_mapping_hash) }

      it 'has correct destination key' do
        expect{ subject.get_statement_for('destination2') }.not_to raise_error
      end
      it 'is a MappingStatement' do
        expect(subject.get_statement_for('destination2')).to be_a DataMaps::Statement
      end
      it 'has the correct statement options' do
        statement = subject.get_statement_for('destination2')

        expect(statement.from).to eq %w[ source2 source3 ]
        expect(statement.to).to eq 'destination2'
        expect(statement.conditions).to be_a Array
        expect(statement.conditions).to be_empty

        expect(statement.converter.length).to eq 1
        expect(statement.converter.all?{ |c| c.is_a?(DataMaps::Converter::Base) }).to be_truthy
      end
    end
  end

  describe 'validation' do
    it 'valid? returns true for complex_mapping_hash' do
      mapping = DataMaps::Mapping.new(complex_mapping_hash)
      expect(mapping.valid?).to be_truthy
    end

    it 'valid? returns false for invalid_mapping_hash' do
      mapping = DataMaps::Mapping.new(invalid_mapping_hash)
      expect(mapping.valid?).to be_falsey
    end
  end

  describe '#each_statement' do
    subject{ DataMaps::Mapping.new(simple_mapping_hash) }

    it 'return an Enumerator if no block given' do
      expect(subject.each_statement).to be_a Enumerator
    end

    it 'calls the given block with destination field name and statement' do
      expect do |block|
        subject.each_statement(&block)
      end.to yield_successive_args(
        ['destination1', DataMaps::Statement],
        ['destination2', DataMaps::Statement]
      )
    end
  end

  describe '#execute' do
    subject{ DataMaps::Mapping.new(complex_mapping_hash) }

    it 'executes each statement' do
      data = {}
      i = 1
      subject.each_statement do |destination, statement|
        expect(statement).to receive(:execute).with(data).and_return([destination, "value #{i}"])
        i += 1
      end

      expect(subject.execute(data)).to eq({ 'destination1' => 'value 1', 'destination2' => 'value 2' })
    end

    it 'filters FilteredValue from result' do
      data = {}

      subject.compile

      expect(subject.mapping['destination1']).to receive(:execute).with(data).and_return(['destination1', 'value 1'])
      expect(subject.mapping['destination2']).to receive(:execute).with(data).and_return(['destination2', DataMaps::FilteredValue.new('value 2')])

      expect(subject.execute(data)).to eq({ 'destination1' => 'value 1' })
    end
  end
end
