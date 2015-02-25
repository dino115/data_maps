require 'spec_helper'

describe DataMaps::Converter::Numeric do
  describe '#execute' do
    describe 'Integer' do
      subject { DataMaps::Converter::Numeric.new('Integer') }

      it 'converts a float' do
        expect(subject.execute(5.5)).to eq 5
      end

      it 'converts a float string' do
        expect(subject.execute('5.5')).to eq 5
      end

      it 'converts a string' do
        expect(subject.execute('5')).to eq 5
      end

      it 'raise an error if the string is not a numeric string' do
        expect{ subject.execute('5,50€') }.to raise_error DataMaps::Errors::InvalidDataError
      end
    end

    describe 'Float' do
      subject { DataMaps::Converter::Numeric.new('Float') }

      it 'converts an integer' do
        expect(subject.execute(5)).to eq 5.0
      end

      it 'converts a float string' do
        expect(subject.execute('5.5')).to eq 5.5
      end

      it 'converts a string' do
        expect(subject.execute('5')).to eq 5.0
      end
    end

    describe 'precision' do
      subject { DataMaps::Converter::Numeric.new(2) }

      it 'converts an integer' do
        expect(subject.execute(5)).to eq 5.0
      end

      it 'converts a float' do
        expect(subject.execute(5.128)).to eq 5.13
      end

      it 'converts a float string' do
        expect(subject.execute('5.128')).to eq 5.13
      end

      it 'converts a string' do
        expect(subject.execute('5')).to eq 5.0
      end
    end

    describe 'no options' do
      subject { DataMaps::Converter::Numeric.new(nil) }

      it 'returns the given numeric data without any modification' do
        expect(subject.execute(5)). to eq 5
      end

      it 'returns the given float data without any modification' do
        expect(subject.execute(5.5)). to eq 5.5
      end

      it 'returns the given string data without any modification' do
        expect(subject.execute('5')). to eq '5'
      end

      it 'raise an error for invalid data' do
        expect{ subject.execute({ something: 'huh' }) }.to raise_error DataMaps::Errors::InvalidDataError
      end
    end
  end
end
