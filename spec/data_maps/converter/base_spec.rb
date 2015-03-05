require 'spec_helper'

describe DataMaps::Converter do
  describe '::factory_from_map' do
    it 'creates new converter' do
      mapping = { ruby: :upcase }

      expect(DataMaps::Converter).to receive(:factory).with(:ruby, :upcase).and_call_original

      DataMaps::Converter.factory_from_map(mapping)
    end
  end

  describe '::create_from_map' do
    it 'creates new converter from an array of hashes' do
      mapping = [ { apply: :ruby, option: :upcase }, { apply: :string } ]

      expect(DataMaps::Converter).to receive(:factory).ordered.with(:ruby, :upcase).and_call_original
      expect(DataMaps::Converter).to receive(:factory).ordered.with(:string, nil).and_call_original

      DataMaps::Converter.create_from_map(mapping)
    end

    it 'creates new converter from an array of converter names without options' do
      mapping = [ :string, :numeric ]

      expect(DataMaps::Converter).to receive(:factory).ordered.with(:string, nil).and_call_original
      expect(DataMaps::Converter).to receive(:factory).ordered.with(:numeric, nil).and_call_original

      DataMaps::Converter.create_from_map(mapping)
    end

    it 'creates new converter from an array of mixed types' do
      mapping = [ { apply: :ruby, option: :upcase }, :string ]

      expect(DataMaps::Converter).to receive(:factory).ordered.with(:ruby, :upcase).and_call_original
      expect(DataMaps::Converter).to receive(:factory).ordered.with(:string, nil).and_call_original

      DataMaps::Converter.create_from_map(mapping)
    end
  end
end

describe DataMaps::Converter::Base do
  subject { DataMaps::Converter::Base.new('muh') }

  it 'is an executable' do
    expect(subject).to be_a DataMaps::Executable
  end
end
