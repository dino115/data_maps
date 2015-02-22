require 'spec_helper'

describe DataMaps::Then do
  describe '::create_from_map' do
    it 'creates a new Statement' do
      mapping = { filter: true }

      expect(DataMaps::Then).to receive(:factory).with(:filter, true).and_call_original

      DataMaps::Then.create_from_map(mapping)
    end
  end
end

describe DataMaps::Then::Base do
  subject { DataMaps::Then::Base.new('muh') }

  describe 'arguments' do
    it 'first argument is available via option attribute reader' do
      expect(subject.option).to eq 'muh'
    end
  end

  describe '#result' do
    it 'raise an NotImplementedError' do
      expect{ subject.result('something') }.to raise_error NotImplementedError
    end
  end
end
