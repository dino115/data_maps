require 'spec_helper'

describe DataMaps::When do
  describe '::create_from_map' do
    it 'creates a new Statement' do
      mapping = { empty: true }

      expect(DataMaps::When).to receive(:factory).with(:empty, true).and_call_original

      DataMaps::When.create_from_map(mapping)
    end
  end
end

describe DataMaps::When::Base do
  subject { DataMaps::When::Base.new('muh') }

  describe 'arguments' do
    it 'first argument is available via option attribute reader' do
      expect(subject.option).to eq 'muh'
    end
  end

  describe '#check' do
    it 'raise an NotImplementedError' do
      expect{ subject.check('something') }.to raise_error NotImplementedError
    end
  end
end
