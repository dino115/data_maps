require 'spec_helper'

describe DataMaps::Converter::Prefix do
  subject { DataMaps::Converter::Prefix.new('PREFIX') }

  describe '#apply' do
    describe 'for Arrays' do
      it 'cast all values to strings' do
        data = [double(Object), double(Object)]

        expect(data[0]).to receive(:to_s).and_return(String.new)
        expect(data[1]).to receive(:to_s).and_return(String.new)

        expect(
          subject.apply(data).all?{ |x| x.is_a?(String) }
        ).to be_truthy
      end

      it 'prefixes all values' do
        expect(
          subject.apply(%w[ a b c ])
        ).to eq %w[ PREFIXa PREFIXb PREFIXc ]
      end
    end

    describe 'for Hashes' do
      it 'cast all values to strings' do
        data = { a: double(Object), b: double(Object) }

        expect(data[:a]).to receive(:to_s).and_return(String.new)
        expect(data[:b]).to receive(:to_s).and_return(String.new)

        expect(
          subject.apply(data).all?{ |k,v| v.is_a?(String) }
        ).to be_truthy
      end

      it 'prefixes all values' do
        expect(
          subject.apply({ a: 'a', b: 'b', c: 'c' })
        ).to eq({ a: 'PREFIXa', b: 'PREFIXb', c: 'PREFIXc' })
      end
    end

    describe 'for flat values' do
      it 'cast value to string' do
        data = double(Object)

        expect(data).to receive(:to_s).and_return(String.new)
        expect(subject.apply(data)).to be_a String
      end

      it 'prefixes the value' do
        expect(
          subject.apply('a')
        ).to eq 'PREFIXa'
      end
    end
  end
end

describe DataMaps::Converter::Postfix do
  subject { DataMaps::Converter::Postfix.new('POSTFIX') }

  describe '#apply' do
    describe 'for Arrays' do
      it 'cast all values to strings' do
        data = [double(Object), double(Object)]

        expect(data[0]).to receive(:to_s).and_return(String.new)
        expect(data[1]).to receive(:to_s).and_return(String.new)

        expect(
          subject.apply(data).all?{ |x| x.is_a?(String) }
        ).to be_truthy
      end

      it 'postfixes all values' do
        expect(
          subject.apply(%w[ a b c ])
        ).to eq %w[ aPOSTFIX bPOSTFIX cPOSTFIX ]
      end
    end

    describe 'for Hashes' do
      it 'cast all values to strings' do
        data = { a: double(Object), b: double(Object) }

        expect(data[:a]).to receive(:to_s).and_return(String.new)
        expect(data[:b]).to receive(:to_s).and_return(String.new)

        expect(
          subject.apply(data).all?{ |k,v| v.is_a?(String) }
        ).to be_truthy
      end

      it 'postfixes all values' do
        expect(
          subject.apply({ a: 'a', b: 'b', c: 'c' })
        ).to eq({ a: 'aPOSTFIX', b: 'bPOSTFIX', c: 'cPOSTFIX' })
      end
    end

    describe 'for flat values' do
      it 'cast value to string' do
        data = double(Object)

        expect(data).to receive(:to_s).and_return(String.new)
        expect(subject.apply(data)).to be_a String
      end

      it 'postfixes the value' do
        expect(
          subject.apply('a')
        ).to eq 'aPOSTFIX'
      end
    end
  end
end
