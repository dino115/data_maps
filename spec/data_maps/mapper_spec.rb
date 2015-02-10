require 'spec_helper'

describe DataMaps::Mapper do

  it 'cant\'t be initialized without a mapping' do
    expect{ DataMaps::Mapper.new }.to raise_error ArgumentError
  end

  it 'cant\t be initialized with an invalid mapping' do
    expect{ DataMaps::Mapper.new('something') }.to raise_error ArgumentError
  end

end
