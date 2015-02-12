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
      expect{ MyModule.factory('C', nil) }.to raise_error ArgumentError
    end

    it 'returns instance of the given class' do
      expect(MyModule.factory('A', nil)).to be_a MyModule::A
    end

    it 'pass option to the new class' do
      option = 1
      expect(MyModule::A).to receive(:new).with(option)

      MyModule.factory('A', option)
    end
  end
end
