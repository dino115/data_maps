require 'spec_helper'

describe DataMaps::When::Gt do
  subject { DataMaps::When::Gt.new(5) }

  describe '#execute' do
    it 'returns true if data is greater than 5' do
      expect(subject.execute(6)).to be_truthy
    end

    it 'returns false if data equals 5' do
      expect(subject.execute(5)).to be_falsey
    end

    it 'returns false if data is lower than 5' do
      expect(subject.execute(4)).to be_falsey
    end
  end
end

describe DataMaps::When::Gte do
  subject { DataMaps::When::Gte.new(5) }

  describe '#execute' do
    it 'returns true if data is greater than 5' do
      expect(subject.execute(6)).to be_truthy
    end

    it 'returns true if data equals 5' do
      expect(subject.execute(5)).to be_truthy
    end

    it 'returns false if data is lower than 5' do
      expect(subject.execute(4)).to be_falsey
    end
  end
end

describe DataMaps::When::Lt do
  subject { DataMaps::When::Lt.new(5) }

  describe '#execute' do
    it 'returns false if data is greater than 5' do
      expect(subject.execute(6)).to be_falsey
    end

    it 'returns false if data equals 5' do
      expect(subject.execute(5)).to be_falsey
    end

    it 'returns true if data is lower than 5' do
      expect(subject.execute(4)).to be_truthy
    end
  end
end

describe DataMaps::When::Lte do
  subject { DataMaps::When::Lte.new(5) }

  describe '#execute' do
    it 'returns false if data is greater than 5' do
      expect(subject.execute(6)).to be_falsey
    end

    it 'returns true if data equals 5' do
      expect(subject.execute(5)).to be_truthy
    end

    it 'returns true if data is lower than 5' do
      expect(subject.execute(4)).to be_truthy
    end
  end
end

describe DataMaps::When::Eq do
  subject { DataMaps::When::Eq.new(5) }

  describe '#execute' do
    it 'returns true if data equals 5' do
      expect(subject.execute(5)).to be_truthy
    end

    it 'returns false if data not equals 5' do
      expect(subject.execute(6)).to be_falsey
    end
  end
end

describe DataMaps::When::Neq do
  subject { DataMaps::When::Neq.new(5) }

  describe '#execute' do
    it 'returns true if data not equals 5' do
      expect(subject.execute(6)).to be_truthy
    end

    it 'returns false if data equals 5' do
      expect(subject.execute(5)).to be_falsey
    end
  end
end

describe DataMaps::When::In do
  subject { DataMaps::When::In.new([1,2,3,4]) }

  describe '#execute' do
    it 'returns true if data is in option' do
      expect(subject.execute(2)).to be_truthy
    end

    it 'returns false if data is not in option' do
      expect(subject.execute(5)).to be_falsey
    end
  end
end

describe DataMaps::When::Nin do
  subject { DataMaps::When::Nin.new([1,2,3,4]) }

  describe '#execute' do
    it 'returns false if data is in option' do
      expect(subject.execute(2)).to be_falsey
    end

    it 'returns true if data is not in option' do
      expect(subject.execute(5)).to be_truthy
    end
  end
end
