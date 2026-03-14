# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveMosaic::Helpers::Mosaic do
  subject(:mosaic) do
    described_class.new(name: 'Decision Map', pattern_category: :geometric)
  end

  describe '#initialize' do
    it 'sets name' do
      expect(mosaic.name).to eq('Decision Map')
    end

    it 'sets pattern category' do
      expect(mosaic.pattern_category).to eq(:geometric)
    end

    it 'defaults capacity to 50' do
      expect(mosaic.capacity).to eq(50)
    end

    it 'defaults grout_strength to 0.8' do
      expect(mosaic.grout_strength).to eq(0.8)
    end

    it 'starts empty' do
      expect(mosaic.empty?).to be true
    end

    it 'rejects unknown pattern categories' do
      expect { described_class.new(name: 'x', pattern_category: :random) }
        .to raise_error(ArgumentError, /unknown pattern category/)
    end
  end

  describe '#add_tessera' do
    it 'adds tessera id' do
      expect(mosaic.add_tessera('t1')).to be true
      expect(mosaic.size).to eq(1)
    end

    it 'rejects duplicates' do
      mosaic.add_tessera('t1')
      expect(mosaic.add_tessera('t1')).to be false
    end

    it 'rejects when full' do
      m = described_class.new(name: 'tiny', pattern_category: :organic, capacity: 1)
      m.add_tessera('t1')
      expect(m.add_tessera('t2')).to be false
    end
  end

  describe '#remove_tessera' do
    it 'removes existing tessera' do
      mosaic.add_tessera('t1')
      expect(mosaic.remove_tessera('t1')).to be true
      expect(mosaic.size).to eq(0)
    end

    it 'returns false for missing tessera' do
      expect(mosaic.remove_tessera('nope')).to be false
    end
  end

  describe '#completeness' do
    it 'returns 0.0 when empty' do
      expect(mosaic.completeness).to eq(0.0)
    end

    it 'increases with tesserae' do
      5.times { |i| mosaic.add_tessera("t#{i}") }
      expect(mosaic.completeness).to eq(0.1)
    end
  end

  describe '#erode_grout!' do
    it 'reduces grout strength' do
      old = mosaic.grout_strength
      mosaic.erode_grout!
      expect(mosaic.grout_strength).to be < old
    end
  end

  describe '#reinforce_grout!' do
    it 'increases grout strength' do
      mosaic.erode_grout!(rate: 0.3)
      old = mosaic.grout_strength
      mosaic.reinforce_grout!
      expect(mosaic.grout_strength).to be > old
    end
  end

  describe '#crumbling?' do
    it 'returns false at default strength' do
      expect(mosaic.crumbling?).to be false
    end

    it 'returns true when grout decays heavily' do
      20.times { mosaic.erode_grout!(rate: 0.1) }
      expect(mosaic.crumbling?).to be true
    end
  end

  describe '#gap_count' do
    it 'equals capacity when empty' do
      expect(mosaic.gap_count).to eq(50)
    end
  end

  describe '#to_h' do
    it 'returns all keys' do
      h = mosaic.to_h
      %i[id name pattern_category tessera_ids size capacity
         completeness completeness_label grout_strength gap_count
         full empty crumbling created_at].each do |k|
        expect(h).to have_key(k)
      end
    end
  end
end
