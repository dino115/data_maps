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

  describe 'arguments' do
    it 'first argument is available via option attribute reader' do
      expect(subject.option).to eq 'muh'
    end
  end

  describe '#apply' do
    it 'raise an NotImplementedError' do
      expect{ subject.apply('something') }.to raise_error NotImplementedError
    end
  end
end
