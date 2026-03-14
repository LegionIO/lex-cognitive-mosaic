# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveMosaic
      module Runners
        module CognitiveMosaic
          extend self

          def create_tessera(material:, domain:, content:,
                             color: nil, fit_quality: nil, engine: nil, **)
            eng = resolve_engine(engine)
            t   = eng.create_tessera(material: material, domain: domain,
                                     content: content, color: color,
                                     fit_quality: fit_quality)
            { success: true, tessera: t.to_h }
          rescue ArgumentError => e
            { success: false, error: e.message }
          end

          def create_mosaic(name:, pattern_category:, capacity: 50,
                            grout_strength: nil, engine: nil, **)
            eng = resolve_engine(engine)
            m   = eng.create_mosaic(name: name, pattern_category: pattern_category,
                                    capacity: capacity, grout_strength: grout_strength)
            { success: true, mosaic: m.to_h }
          rescue ArgumentError => e
            { success: false, error: e.message }
          end

          def place_tessera(tessera_id:, mosaic_id:, engine: nil, **)
            eng = resolve_engine(engine)
            t   = eng.place_tessera(tessera_id: tessera_id, mosaic_id: mosaic_id)
            { success: true, tessera: t.to_h }
          rescue ArgumentError => e
            { success: false, error: e.message }
          end

          def list_tesserae(engine: nil, material: nil, **)
            eng     = resolve_engine(engine)
            results = eng.all_tesserae
            results = results.select { |t| t.material == material.to_sym } if material
            { success: true, tesserae: results.map(&:to_h), count: results.size }
          end

          def list_mosaics(engine: nil, **)
            eng = resolve_engine(engine)
            { success: true, mosaics: eng.all_mosaics.map(&:to_h),
              count: eng.all_mosaics.size }
          end

          def mosaic_status(engine: nil, **)
            eng = resolve_engine(engine)
            { success: true, report: eng.mosaic_report }
          end

          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)

          private

          def resolve_engine(engine)
            engine || default_engine
          end

          def default_engine
            @default_engine ||= Helpers::MosaicEngine.new
          end
        end
      end
    end
  end
end
