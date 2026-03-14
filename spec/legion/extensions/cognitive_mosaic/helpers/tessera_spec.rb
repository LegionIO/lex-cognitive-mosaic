# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveMosaic::Helpers::Tessera do
  subject(:tessera) do
    described_class.new(material: :glass, domain: :reasoning, content: 'fragment')
  end

  describe '#initialize' do
    it 'sets material' do
      expect(tessera.material).to eq(:glass)
    end

    it 'sets domain' do
      expect(tessera.domain).to eq(:reasoning)
    end

    it 'generates uuid' do
      expect(tessera.id).to match(/\A[0-9a-f-]{36}\z/)
    end

    it 'assigns a color' do
      expect(tessera.color).to be_a(Symbol)
    end

    it 'defaults fit_quality to 0.5' do
      expect(tessera.fit_quality).to eq(0.5)
    end

    it 'starts unplaced' do
      expect(tessera.loose?).to be true
    end

    it 'rejects unknown materials' do
      expect { described_class.new(material: :plasma, domain: :x, content: 'y') }
        .to raise_error(ArgumentError, /unknown material/)
    end

    it 'accepts custom fit_quality' do
      t = described_class.new(material: :stone, domain: :x, content: 'y', fit_quality: 0.95)
      expect(t.fit_quality).to eq(0.95)
    end
  end

  describe '#place!' do
    it 'marks tessera as placed' do
      tessera.place!('mosaic-1')
      expect(tessera.placed?).to be true
    end

    it 'records mosaic id' do
      tessera.place!('mosaic-1')
      expect(tessera.mosaic_id).to eq('mosaic-1')
    end

    it 'records placement time' do
      tessera.place!('mosaic-1')
      expect(tessera.placed_at).to be_a(Time)
    end
  end

  describe '#perfect_fit?' do
    it 'returns false at default quality' do
      expect(tessera.perfect_fit?).to be false
    end

    it 'returns true at high quality' do
      t = described_class.new(material: :crystal, domain: :x, content: 'y', fit_quality: 0.95)
      expect(t.perfect_fit?).to be true
    end
  end

  describe '#poor_fit?' do
    it 'returns false at default quality' do
      expect(tessera.poor_fit?).to be false
    end

    it 'returns true at low quality' do
      t = described_class.new(material: :clay, domain: :x, content: 'y', fit_quality: 0.1)
      expect(t.poor_fit?).to be true
    end
  end

  describe '#to_h' do
    it 'returns all keys' do
      h = tessera.to_h
      %i[id material domain content color fit_quality
         placed loose perfect_fit poor_fit mosaic_id placed_at].each do |k|
        expect(h).to have_key(k)
      end
    end
  end
end
