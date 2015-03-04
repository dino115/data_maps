require 'spec_helper'

describe DataMaps::When do
  describe '::factory_from_map' do
    it 'creates new whens' do
      mapping = { empty: true }

      expect(DataMaps::When).to receive(:factory).with(:empty, true).and_call_original

      DataMaps::When.factory_from_map(mapping)
    end
  end
end

describe DataMaps::When::Base do
  subject { DataMaps::When::Base.new('muh') }

  it 'is an executable' do
    expect(subject).to be_a DataMaps::Executable
  end
end
