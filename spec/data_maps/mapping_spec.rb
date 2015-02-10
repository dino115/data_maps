require 'spec_helper'

describe DataMaps::Mapping do

  it 'cant\t be initialized without a valid mapping_hash' do
    expect{ DataMaps::Mapping.new('something') }.to raise_error ArgumentError
  end

  describe 'map generation' do
    # Test mapping generation of a simple destination => source mapping without any conditions or converter
    describe 'simple key, value pair' do
      let(:mapping_hash) do
        { 'my_destination' => 'my_source' }
      end

      subject{ DataMaps::Mapping.new(mapping_hash) }

      it 'has key my_destination' do
        expect{ subject.get_statement_for('my_destination') }.not_to raise_error
      end
      it 'is a MappingStatement' do
        expect(subject.get_statement_for('my_destination')).to be_a DataMaps::Statement
      end
      it 'has the correct statement options' do
        statement = subject.get_statement_for('my_destination')

        expect(statement.destination_field).to eq 'my_destination'
        expect(statement.source_field).to eq 'my_source'
        expect(statement.conditions).to be_empty
        expect(statement.converter).to be_empty
      end
    end

    # Test a mapping generation with one condition
    describe 'with one condition' do
      let(:mapping_hash) do
        { 'my_destination' => { source_field: 'my_source', conditions: 'not_empty' } }
      end

      subject{ DataMaps::Mapping.new(mapping_hash) }

      it 'has the correct statement options' do
        statement = subject.get_statement_for('my_destination')

        expect(statement.destination_field).to eq 'my_destination'
        expect(statement.source_field).to eq 'my_source'
        expect(statement.conditions.length).to eq 1
        expect(statement.conditions.first).to be_a DataMaps::Conditions::NotEmpty
        expect(statement.converter).to be_empty
      end
    end

    # Test a mapping generation with multiple conditions and options
    describe 'with multiple conditions and options' do
      let(:mapping_hash) do
        {
          'my_destination' => {
            source_field: 'my_source',
            conditions: {
              'not_empty' => nil,
              'regex' => /[a-z]/i
            }
          }
        }
      end

      subject{ DataMaps::Mapping.new(mapping_hash) }

      it 'has the correct statement options' do
        statement = subject.get_statement_for('my_destination')

        expect(statement.destination_field).to eq 'my_destination'
        expect(statement.source_field).to eq 'my_source'
        expect(statement.conditions.length).to eq 2

        expect(statement.conditions[0]).to be_a DataMaps::Conditions::NotEmpty

        expect(statement.conditions[1]).to be_a DataMaps::Conditions::Regex
        expect(statement.conditions[1].regex).to eq /[a-z]/i

        expect(statement.converter).to be_empty
      end
    end

    # Test a mapping generation with one converter
    describe 'with one converter' do
      let(:mapping_hash) do
        { 'my_destination' => { source_field: 'my_source', converter: 'numeric' } }
      end

      subject{ DataMaps::Mapping.new(mapping_hash) }

      it 'has the correct statement options' do
        statement = subject.get_statement_for('my_destination')

        expect(statement.destination_field).to eq 'my_destination'
        expect(statement.source_field).to eq 'my_source'
        expect(statement.conditions).to be_empty
        expect(statement.converter.length).to eq 1
        expect(statement.converter.first).to be_a DataMaps::Converter::Numeric
        expect(statement.converter.first.options).to be_empty
      end
    end

    # Test a mapping generation with multiple converters and options
    describe 'with multiple converters and options' do
      let(:mapping_hash) do
        {
          'my_destination' => {
            source_field: 'my_source',
            converter: {
              'numeric' => nil,
              'selection' => { '1' => 'A', '2' => 'B', '3' => 'C', '4' => 'D', '5' => 'E', '6' => 'F' },
            }
          }
        }
      end

      subject{ DataMaps::Mapping.new(mapping_hash) }

      it 'has the correct statement options' do
        statement = subject.get_statement_for('my_destination')

        expect(statement.destination_field).to eq 'my_destination'
        expect(statement.source_field).to eq 'my_source'
        expect(statement.conditions).to be_empty
        expect(statement.converter.length).to eq 2

        expect(statement.converter[0]).to be_a DataMaps::Converter::Numeric
        expect(statement.converter[0].options).to be_nil

        expect(statement.converter[1]).to be_a DataMaps::Converter::Selection
        expect(statement.converter[1].options).to eq({ '1' => 'A', '2' => 'B', '3' => 'C', '4' => 'D', '5' => 'E', '6' => 'F' })
      end
    end
  end
end
