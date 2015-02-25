require 'spec_helper'

describe DataMaps::Then::Set do
  subject { DataMaps::Then::Set.new('NEW VALUE') }

  describe '#execute' do
    it 'return option always' do
      expect(subject.execute('something')).to eq 'NEW VALUE'
    end
  end
end
