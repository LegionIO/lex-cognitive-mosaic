# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveMosaic
      module Helpers
        module Constants
          # Tessera material types
          MATERIAL_TYPES = %i[
            glass stone ceramic metal wood
            shell bone crystal clay enamel
          ].freeze

          # Mosaic pattern categories
          PATTERN_CATEGORIES = %i[
            geometric organic abstract narrative
            symbolic decorative functional
          ].freeze

          MAX_TESSERAE = 500
          MAX_MOSAICS  = 50
          GROUT_DECAY  = 0.01
          MIN_GROUT    = 0.05

          # Completeness labels
          COMPLETENESS_LABELS = [
            [(0.9..),      :masterwork],
            [(0.7...0.9),  :substantial],
            [(0.5...0.7),  :emerging],
            [(0.3...0.5),  :fragmentary],
            [(..0.3),      :nascent]
          ].freeze

          # Coherence labels
          COHERENCE_LABELS = [
            [(0.8..),      :harmonious],
            [(0.6...0.8),  :coherent],
            [(0.4...0.6),  :developing],
            [(0.2...0.4),  :disjointed],
            [(..0.2),      :chaotic]
          ].freeze

          def self.label_for(table, value)
            table.each { |range, label| return label if range.cover?(value) }
            table.last.last
          end
        end
      end
    end
  end
end
