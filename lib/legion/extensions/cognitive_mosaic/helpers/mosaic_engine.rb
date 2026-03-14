# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveMosaic
      module Helpers
        class MosaicEngine
          def initialize
            @tesserae = {}
            @mosaics  = {}
          end

          def create_tessera(material:, domain:, content:, color: nil, fit_quality: nil)
            raise ArgumentError, 'tessera limit reached' if @tesserae.size >= Constants::MAX_TESSERAE

            t = Tessera.new(material: material, domain: domain, content: content,
                            color: color, fit_quality: fit_quality)
            @tesserae[t.id] = t
            t
          end

          def create_mosaic(name:, pattern_category:, capacity: 50, grout_strength: nil)
            raise ArgumentError, 'mosaic limit reached' if @mosaics.size >= Constants::MAX_MOSAICS

            m = Mosaic.new(name: name, pattern_category: pattern_category,
                           capacity: capacity, grout_strength: grout_strength)
            @mosaics[m.id] = m
            m
          end

          def place_tessera(tessera_id:, mosaic_id:)
            tessera = fetch_tessera(tessera_id)
            mosaic  = fetch_mosaic(mosaic_id)

            raise ArgumentError, 'tessera already placed' if tessera.placed?
            raise ArgumentError, 'mosaic is full' if mosaic.full?

            mosaic.add_tessera(tessera_id)
            tessera.place!(mosaic_id)
          end

          def erode_all_grout!(rate: Constants::GROUT_DECAY)
            @mosaics.each_value { |m| m.erode_grout!(rate: rate) }
            crumbling = @mosaics.count { |_, m| m.crumbling? }
            { total: @mosaics.size, crumbling: crumbling }
          end

          def most_complete(limit: 5)
            @mosaics.values.sort_by { |m| -m.completeness }.first(limit)
          end

          def most_gaps(limit: 5)
            @mosaics.values.sort_by { |m| -m.gap_count }.first(limit)
          end

          def loose_tesserae
            @tesserae.values.select(&:loose?)
          end

          def tesserae_by_material
            counts = Constants::MATERIAL_TYPES.to_h { |m| [m, 0] }
            @tesserae.each_value { |t| counts[t.material] += 1 }
            counts
          end

          def coherence(mosaic_id:)
            mosaic = fetch_mosaic(mosaic_id)
            return 0.0 if mosaic.empty?

            placed = mosaic.tessera_ids.filter_map { |id| @tesserae[id] }
            return 0.0 if placed.empty?

            avg_fit = placed.sum(&:fit_quality) / placed.size
            grout_factor = mosaic.grout_strength
            ((avg_fit + grout_factor) / 2.0).clamp(0.0, 1.0).round(10)
          end

          def coherence_label(mosaic_id:)
            Constants.label_for(Constants::COHERENCE_LABELS, coherence(mosaic_id: mosaic_id))
          end

          def mosaic_report
            {
              total_tesserae:   @tesserae.size,
              total_mosaics:    @mosaics.size,
              loose_count:      loose_tesserae.size,
              by_material:      tesserae_by_material,
              crumbling_count:  @mosaics.count { |_, m| m.crumbling? },
              avg_completeness: avg_completeness
            }
          end

          def all_tesserae
            @tesserae.values
          end

          def all_mosaics
            @mosaics.values
          end

          private

          def fetch_tessera(id)
            @tesserae.fetch(id) { raise ArgumentError, "tessera not found: #{id}" }
          end

          def fetch_mosaic(id)
            @mosaics.fetch(id) { raise ArgumentError, "mosaic not found: #{id}" }
          end

          def avg_completeness
            return 0.0 if @mosaics.empty?

            (@mosaics.values.sum(&:completeness) / @mosaics.size).round(10)
          end
        end
      end
    end
  end
end
