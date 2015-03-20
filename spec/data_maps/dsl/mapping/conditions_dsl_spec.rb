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

  describe '#when' do
    it 'adds a when with correct options to the whens hash' do
      expect{ subject.when(:regex, /[0-9]/) }.to change{ subject.whens.length }.from(0).to(1)

      expect(subject.whens.key?(:regex)).to be_truthy
      expect(subject.whens[:regex]).to eq /[0-9]/
    end
  end

  describe '#then' do
    it 'adds a then with correct options to the thens hash' do
      expect{ subject.then(:filter, true) }.to change{ subject.thens.length }.from(0).to(1)

      expect(subject.thens.key?(:filter)).to be_truthy
      expect(subject.thens[:filter]).to be_truthy
    end
  end
end
