# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveMosaic::Helpers::Constants do
  describe 'MATERIAL_TYPES' do
    it 'has 10 material types' do
      expect(described_class::MATERIAL_TYPES.size).to eq(10)
    end

    it 'includes core materials' do
      %i[glass stone ceramic].each do |m|
        expect(described_class::MATERIAL_TYPES).to include(m)
      end
    end
  end

  describe 'PATTERN_CATEGORIES' do
    it 'includes standard categories' do
      %i[geometric organic abstract narrative].each do |c|
        expect(described_class::PATTERN_CATEGORIES).to include(c)
      end
    end
  end

  describe '.label_for' do
    it 'returns masterwork for high completeness' do
      expect(described_class.label_for(described_class::COMPLETENESS_LABELS, 0.95)).to eq(:masterwork)
    end

    it 'returns nascent for low completeness' do
      expect(described_class.label_for(described_class::COMPLETENESS_LABELS, 0.1)).to eq(:nascent)
    end

    it 'returns harmonious for high coherence' do
      expect(described_class.label_for(described_class::COHERENCE_LABELS, 0.9)).to eq(:harmonious)
    end
  end
end
