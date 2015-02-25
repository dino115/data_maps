require 'spec_helper'

describe DataMaps::Concerns::Factory do

  module MyModule
    extend DataMaps::Concerns::Factory

    class A
      def initialize(option); end
    end

    class B
      def initialize(option); end
    end
  end

  it 'module respond_to factory class method' do
    expect(MyModule).to respond_to :factory
  end

  describe '#factory' do
    it 'raise error if constant doesn\'t exists in the module' do
      expect{ MyModule.factory('c', nil) }.to raise_error ArgumentError
    end

    it 'returns instance of the given class' do
      expect(MyModule.factory('a', nil)).to be_a MyModule::A
    end

    it 'works with symbols too' do
      expect(MyModule.factory(:a, nil)).to be_a MyModule::A
    end

    it 'pass option to the new class' do
      option = 1
      expect(MyModule::A).to receive(:new).with(option)

      MyModule.factory('A', option)
    end
  end

  describe '#create_from_map' do
    it 'raises an error if mapping isn\'t a hash' do
      expect{ MyModule.create_from_map([]) }.to raise_error ArgumentError
      expect{ MyModule.create_from_map('something') }.to raise_error ArgumentError
    end

    it 'calls the factory method' do
      mapping = { a: :b }
      expect(MyModule).to receive(:factory).with(:a, :b).and_call_original
      MyModule.create_from_map(mapping)
    end
  end
end
