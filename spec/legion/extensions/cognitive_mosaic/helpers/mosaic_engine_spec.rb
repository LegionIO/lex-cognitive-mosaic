# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveMosaic::Helpers::MosaicEngine do
  subject(:engine) { described_class.new }

  describe '#create_tessera' do
    it 'creates and stores a tessera' do
      t = engine.create_tessera(material: :glass, domain: :reasoning, content: 'test')
      expect(t).to be_a(Legion::Extensions::CognitiveMosaic::Helpers::Tessera)
    end

    it 'raises when limit reached' do
      stub_const('Legion::Extensions::CognitiveMosaic::Helpers::Constants::MAX_TESSERAE', 1)
      engine.create_tessera(material: :glass, domain: :x, content: 'a')
      expect { engine.create_tessera(material: :glass, domain: :x, content: 'b') }
        .to raise_error(ArgumentError, /tessera limit/)
    end
  end

  describe '#create_mosaic' do
    it 'creates and stores a mosaic' do
      m = engine.create_mosaic(name: 'test', pattern_category: :geometric)
      expect(m).to be_a(Legion::Extensions::CognitiveMosaic::Helpers::Mosaic)
    end

    it 'raises when limit reached' do
      stub_const('Legion::Extensions::CognitiveMosaic::Helpers::Constants::MAX_MOSAICS', 1)
      engine.create_mosaic(name: 'a', pattern_category: :organic)
      expect { engine.create_mosaic(name: 'b', pattern_category: :organic) }
        .to raise_error(ArgumentError, /mosaic limit/)
    end
  end

  describe '#place_tessera' do
    it 'places tessera into mosaic' do
      t = engine.create_tessera(material: :stone, domain: :memory, content: 'piece')
      m = engine.create_mosaic(name: 'wall', pattern_category: :abstract)
      engine.place_tessera(tessera_id: t.id, mosaic_id: m.id)
      expect(t.placed?).to be true
      expect(m.size).to eq(1)
    end

    it 'raises for already placed tessera' do
      t = engine.create_tessera(material: :glass, domain: :x, content: 'a')
      m = engine.create_mosaic(name: 'x', pattern_category: :geometric)
      engine.place_tessera(tessera_id: t.id, mosaic_id: m.id)
      m2 = engine.create_mosaic(name: 'y', pattern_category: :organic)
      expect { engine.place_tessera(tessera_id: t.id, mosaic_id: m2.id) }
        .to raise_error(ArgumentError, /already placed/)
    end
  end

  describe '#erode_all_grout!' do
    it 'erodes grout on all mosaics' do
      m = engine.create_mosaic(name: 'wall', pattern_category: :geometric)
      old = m.grout_strength
      engine.erode_all_grout!
      expect(m.grout_strength).to be < old
    end
  end

  describe '#most_complete' do
    it 'returns mosaics by completeness' do
      engine.create_mosaic(name: 'empty', pattern_category: :organic, capacity: 10)
      m2 = engine.create_mosaic(name: 'full', pattern_category: :organic, capacity: 2)
      t1 = engine.create_tessera(material: :glass, domain: :x, content: 'a')
      t2 = engine.create_tessera(material: :glass, domain: :x, content: 'b')
      engine.place_tessera(tessera_id: t1.id, mosaic_id: m2.id)
      engine.place_tessera(tessera_id: t2.id, mosaic_id: m2.id)
      expect(engine.most_complete(limit: 1).first).to eq(m2)
    end
  end

  describe '#loose_tesserae' do
    it 'returns unplaced tesserae' do
      t1 = engine.create_tessera(material: :glass, domain: :x, content: 'loose')
      t2 = engine.create_tessera(material: :stone, domain: :x, content: 'placed')
      m = engine.create_mosaic(name: 'wall', pattern_category: :geometric)
      engine.place_tessera(tessera_id: t2.id, mosaic_id: m.id)
      expect(engine.loose_tesserae).to eq([t1])
    end
  end

  describe '#coherence' do
    it 'returns 0.0 for empty mosaic' do
      m = engine.create_mosaic(name: 'empty', pattern_category: :geometric)
      expect(engine.coherence(mosaic_id: m.id)).to eq(0.0)
    end

    it 'returns positive for populated mosaic' do
      m = engine.create_mosaic(name: 'wall', pattern_category: :geometric)
      t = engine.create_tessera(material: :glass, domain: :x, content: 'a', fit_quality: 0.8)
      engine.place_tessera(tessera_id: t.id, mosaic_id: m.id)
      expect(engine.coherence(mosaic_id: m.id)).to be > 0.0
    end
  end

  describe '#mosaic_report' do
    it 'returns comprehensive report' do
      engine.create_tessera(material: :glass, domain: :x, content: 'a')
      report = engine.mosaic_report
      %i[total_tesserae total_mosaics loose_count by_material
         crumbling_count avg_completeness].each do |k|
        expect(report).to have_key(k)
      end
    end
  end
end
