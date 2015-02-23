require 'spec_helper'

describe 'DataMaps::VERSION' do
  it 'defines a version' do
    expect(DataMaps::VERSION).to be_a String
    expect(DataMaps::VERSION).to match /^\d+\.\d+\.\d+$/
  end
end
