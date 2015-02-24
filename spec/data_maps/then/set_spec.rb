require 'spec_helper'

describe DataMaps::Then::Set do
  subject { DataMaps::Then::Set.new('NEW VALUE') }

  describe '#result' do
    it 'return option always' do
      expect(subject.result('something')).to eq 'NEW VALUE'
    end
  end
end
