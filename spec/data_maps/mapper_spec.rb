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

  describe '#convert' do
    let(:mapping) { DataMaps::Mapping.new({ 'b' => 'a' }) }
    let(:mapper) { DataMaps::Mapper.new(mapping) }

    it 'executes mapping' do
      data = { 'a' => 'x' }
      expect(mapping).to receive(:execute).with(data).and_call_original
      expect(mapper.convert(data)).to eq({ 'b' => 'x' })
    end

    it 'converts keys of the data to string keys' do
      data = { a: 'x' }
      expect(data).to receive(:stringify_keys).and_call_original
      expect(mapper.convert(data)).to eq({ 'b' => 'x' })
    end
  end
end
