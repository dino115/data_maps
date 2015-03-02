require 'spec_helper'

describe DataMaps::Dsl::Mapping::ConditionsDsl do
  subject{ DataMaps::Dsl::Mapping::ConditionsDsl.new }

  describe '#initialze' do
    it 'set whens to an empty hash' do
      expect(subject.whens).to eq({})
    end

    it 'set thens to an empty hash' do
      expect(subject.thens).to eq({})
    end
  end
end
