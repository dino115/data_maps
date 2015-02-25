require 'spec_helper'

describe DataMaps::Converter do
  describe '::create_from_map' do
    it 'creates new converter' do
      mapping = { ruby: :upcase }

      expect(DataMaps::Converter).to receive(:factory).with(:ruby, :upcase).and_call_original

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
