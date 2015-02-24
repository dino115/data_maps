require 'spec_helper'

describe DataMaps::Condition do
  describe '::create_from_map' do
    it 'creates a new Condition' do
      mapping = [
        { when: { empty: true }, then: { filter: true } }
      ]

      expect(DataMaps::When).to receive(:create_from_map).with(mapping.first[:when]).and_call_original
      expect(DataMaps::Then).to receive(:create_from_map).with(mapping.first[:then]).and_call_original

      expect(DataMaps::Condition).to receive(:new).with([DataMaps::When::Empty], [DataMaps::Then::Filter])

      DataMaps::Condition.create_from_map(mapping)
    end
  end

  describe 'arguments' do
    it 'can\'t be initialized without whens' do
      expect{ DataMaps::Condition.new(nil, []) }.to raise_error ArgumentError
    end

    it 'can\'t be initialized with wrong whens' do
      expect{ DataMaps::Condition.new(['a', 5], []) }.to raise_error ArgumentError
    end

    it 'can\'t be initialized without thens' do
      expect{ DataMaps::Condition.new([], nil) }.to raise_error ArgumentError
    end

    it 'can\'t be initialized with wrong thens' do
      expect{ DataMaps::Condition.new([], ['b', 6]) }.to raise_error ArgumentError
    end
  end

  describe '#can_break?' do
    it 'returns false' do
      condition = DataMaps::Condition.new([], [])
      expect(condition.can_break?).to be_falsey
    end

    it 'returns true if there is a Then::Filter present' do
      condition = DataMaps::Condition.new([], [DataMaps::Then::Filter.new(true)])
      expect(condition.can_break?).to be_truthy
    end
  end

  describe '#execute' do
    let(:condition) { DataMaps::Condition.new([DataMaps::When::Base.new(nil)], [DataMaps::Then::Base.new(nil)]) }
    let(:data) { double(Object) }

    it 'returns original data when check is false' do
      expect(condition).to receive(:check).with(data).and_return(false)
      expect(condition.execute(data)).to be data
    end

    it 'returns modified data when check is true and can_break? is false' do
      expect(condition).to receive(:check).with(data).and_return(true)
      expect(condition).to receive(:can_break?).and_return(false)
      expect(condition).to receive(:result).with(data).and_return('modified value')
      expect(condition.execute(data)).to eq 'modified value'
    end

    it 'returns a FilteredValue when check is true and can_break? is true' do
      expect(condition).to receive(:check).with(data).and_return(true)
      expect(condition).to receive(:can_break?).and_return(true)
      expect(condition.execute(data)).to be_a DataMaps::FilteredValue
    end
  end

  describe '#check' do
    let(:condition) { DataMaps::Condition.new([DataMaps::When::Base.new(nil), DataMaps::When::Base.new(nil)], []) }
    let(:data) { double(Object) }

    it 'returns true if all whens are true' do
      expect(condition.whens[0]).to receive(:check).with(data).and_return(true)
      expect(condition.whens[1]).to receive(:check).with(data).and_return(true)

      expect(condition.check(data)).to be_truthy
    end

    it 'returns false if a when is false' do
      expect(condition.whens[0]).to receive(:check).with(data).and_return(true)
      expect(condition.whens[1]).to receive(:check).with(data).and_return(false)

      expect(condition.check(data)).to be_falsey
    end
  end

  describe '#result' do
    let(:condition) { DataMaps::Condition.new([], [DataMaps::Then::Base.new(nil), DataMaps::Then::Base.new(nil)]) }
    let(:data) { double(Object) }
    let(:data2) { double(Object) }
    let(:data3) { double(Object) }

    it 'calls result for each then with the mutated data' do
      expect(condition.thens[0]).to receive(:result).ordered.with(data).and_return(data2)
      expect(condition.thens[1]).to receive(:result).ordered.with(data2).and_return(data3)

      expect(condition.result(data)).to be data3
    end
  end
end
