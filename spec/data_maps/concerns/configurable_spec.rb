require 'spec_helper'

describe DataMaps::Concerns::Configurable do
  class Dummy
    include DataMaps::Concerns::Configurable
  end

  subject{ Dummy.new }

  describe '#configure' do
    it 'evaluates the given block in instance context' do
      expect do |block|
        subject.configure(&block)
      end.to yield_with_args subject
    end

    it 'returns self' do
      expect(subject.configure).to eq subject
    end
  end
end
