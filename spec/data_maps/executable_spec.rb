require 'spec_helper'

describe DataMaps::Executable do
  subject { DataMaps::Executable.new('option') }

  describe 'initialization' do
    it 'first argument is available via option attribute reader' do
      expect(subject.option).to eq 'option'
    end

    it 'calls the after_initialize callback' do
      expect_any_instance_of(DataMaps::Executable).to receive(:after_initialize)

      DataMaps::Executable.new('option')
    end
  end

  describe '#execute' do
    it 'raise an NotImplementedError' do
      expect{ subject.execute('something') }.to raise_error NotImplementedError
    end
  end
end
