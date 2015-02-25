require 'spec_helper'

describe DataMaps::Then do
  describe '::create_from_map' do
    it 'creates new thens' do
      mapping = { filter: true }

      expect(DataMaps::Then).to receive(:factory).with(:filter, true).and_call_original

      DataMaps::Then.create_from_map(mapping)
    end
  end
end

describe DataMaps::Then::Base do
  subject { DataMaps::Then::Base.new('muh') }

  it 'is an executable' do
    expect(subject).to be_a DataMaps::Executable
  end
end
