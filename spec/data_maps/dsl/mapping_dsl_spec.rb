require 'spec_helper'

describe DataMaps::Dsl::Mapping do
  class Dummy
    include DataMaps::Dsl::Mapping

    attr_reader :mapping_hash

    def initialize
      @mapping_hash = {}
    end
  end

  subject{ Dummy.new }

  describe '#field' do
    it 'creates a new FieldMappingDsl object with given options' do
      options = { a: 'A', b: 'B' }
      dsl = DataMaps::Dsl::Mapping::FieldMappingDsl.new

      expect(DataMaps::Dsl::Mapping::FieldMappingDsl).to receive(:new).with(options).and_return(dsl)
      subject.field(:myfield, options)
    end

    it 'calls configure with given block' do
      expect do |block|
        subject.field(:myfield, {}, &block)
      end.to yield_control
    end

    it 'adds the serialized result to the mapping_hash' do
      subject.field(:myfield, {})

      expect(subject.mapping_hash.key?('myfield')).to be_truthy
    end
  end

  describe 'full integration' do
    it 'generates correct mapping hash' do
      mapping = DataMaps::Mapping.new.configure do
        field :myfield, from: :source_field do
          condition do
            is :empty, true
            so :filter, true
          end

          convert :ruby, [:join, ',']
        end
      end

      expect(mapping.mapping_hash).not_to be_empty
      expect(mapping.mapping_hash).to eq(
        {
          'myfield' => {
            'from' => :source_field,
            'conditions' => [
              { 'when' => { 'empty' => true }, 'then' => { 'filter' => true } }
            ],
            'convert' => [
              { 'apply' => :ruby, 'option' => [:join, ','] }
            ]
          }
        }
      )
    end
  end
end
