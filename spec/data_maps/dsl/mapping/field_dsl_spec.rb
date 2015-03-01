require 'spec_helper'

describe DataMaps::Dsl::Mapping::FieldMappingDsl do
  subject{ DataMaps::Dsl::Mapping::FieldMappingDsl.new(from: 'some-field') }

  describe '#initialze' do
    it 'sets the from attribute from options' do
      expect(subject.from).to eq 'some-field'
    end
  end

  describe '#to_h' do
    it 'returns a hash with string keys' do
      expect(subject.to_h).to be_a Hash
      expect(subject.to_h.has_key?('from')).to be_truthy
    end
  end
end
