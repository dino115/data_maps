require 'spec_helper'

describe DataMaps::When::Regex do
  describe 'initialization' do
    it 'creates a regex object from string' do
      expect(DataMaps::When::Regex.new('\d{5}').regex).to be_a Regexp
    end
  end

  describe '#execute' do
    let(:regex) { /^\d{5}$/ }
    subject{ DataMaps::When::Regex.new(regex) }

    it 'calls match on the regex' do
      data = '12345'
      expect(subject.regex).to receive(:match).with(data)

      subject.execute(data)
    end

    it 'return true if match is successful' do
      expect(subject.regex).to receive(:match).and_return(true)
      expect(subject.execute('12345')).to be_truthy
    end

    it 'return false if match is not successful' do
      expect(subject.regex).to receive(:match).and_return(false)
      expect(subject.execute('ab12345')).to be_falsey
    end
  end
end
