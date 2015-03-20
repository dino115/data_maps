require 'spec_helper'

describe DataMaps::Dsl::Mapping::FieldMappingDsl do
  subject{ DataMaps::Dsl::Mapping::FieldMappingDsl.new(from: 'some-field') }

  describe '#initialze' do
    it 'sets the from attribute from options' do
      expect(subject.from).to eq 'some-field'
    end

    it 'sets conditions to an empty array' do
      expect(subject.conditions).to eq []
    end

    it 'sets converter to an empty hash' do
      expect(subject.converter).to eq([])
    end
  end

  describe '#condition' do
    it 'creates a new ConditionsDsl object' do
      dsl = DataMaps::Dsl::Mapping::ConditionsDsl.new

      expect(DataMaps::Dsl::Mapping::ConditionsDsl).to receive(:new).with(no_args).and_return(dsl)
      subject.condition
    end

    it 'calls configure with given block' do
      expect do |block|
        subject.condition(&block)
      end.to yield_control
    end
  end

  describe '#convert' do
    it 'adds the defined converter to converter hash' do
      expect{ subject.convert(:ruby, :downcase) }.to change{ subject.converter.count }.from(0).to(1)
      expect(subject.converter.first).to eq({ apply: :ruby, option: :downcase })
    end
  end

  describe '#to_h' do
    it 'returns a hash with string keys' do
      expect(subject.to_h).to be_a Hash
      expect(subject.to_h.has_key?('from')).to be_truthy
    end
  end
end
