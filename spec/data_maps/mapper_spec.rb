require 'spec_helper'

describe DataMaps::Mapper do
  it 'cant\'t be initialized without a mapping' do
    expect{ DataMaps::Mapper.new }.to raise_error ArgumentError
  end

  it 'cant\t be initialized with an invalid mapping' do
    expect{ DataMaps::Mapper.new('something') }.to raise_error ArgumentError
  end

  describe 'initialisation' do
    it 'sets mapping' do
      mapping = DataMaps::Mapping.new({})
      mapper = DataMaps::Mapper.new(mapping)

      expect(mapper.mapping).to be_a DataMaps::Mapping
      expect(mapper.mapping).to eq mapping
    end
  end
end
