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
          { when: { empty: true }, then: { skip: true } },
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
    conditional_mapping_hash + converter_mapping_hash
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
    describe 'simple key, value pair' do
      subject{ DataMaps::Mapping.new(simple_mapping_hash) }

      it 'has key my_destination' do
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
end
