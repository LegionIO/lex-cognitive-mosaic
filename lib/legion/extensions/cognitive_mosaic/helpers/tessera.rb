# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveMosaic
      module Helpers
        class Tessera
          attr_reader :id, :material, :domain, :content,
                      :color, :placed_at, :mosaic_id
          attr_accessor :fit_quality

          def initialize(material:, domain:, content:,
                         color: nil, fit_quality: nil)
            validate_material!(material)
            @id          = SecureRandom.uuid
            @material    = material.to_sym
            @domain      = domain.to_sym
            @content     = content.to_s
            @color       = (color || random_color).to_sym
            @fit_quality = (fit_quality || 0.5).to_f.clamp(0.0, 1.0).round(10)
            @placed_at   = nil
            @mosaic_id   = nil
          end

          def place!(mosaic_id)
            @mosaic_id = mosaic_id
            @placed_at = Time.now.utc
            self
          end

          def placed?
            !@mosaic_id.nil?
          end

          def loose?
            @mosaic_id.nil?
          end

          def perfect_fit?
            @fit_quality >= 0.9
          end

          def poor_fit?
            @fit_quality < 0.3
          end

          def to_h
            {
              id:          @id,
              material:    @material,
              domain:      @domain,
              content:     @content,
              color:       @color,
              fit_quality: @fit_quality,
              placed:      placed?,
              loose:       loose?,
              perfect_fit: perfect_fit?,
              poor_fit:    poor_fit?,
              mosaic_id:   @mosaic_id,
              placed_at:   @placed_at
            }
          end

          private

          def random_color
            %i[red blue green gold white black silver amber
               turquoise crimson ivory jade].sample
          end

          def validate_material!(val)
            return if Constants::MATERIAL_TYPES.include?(val.to_sym)

            raise ArgumentError,
                  "unknown material: #{val.inspect}; " \
                  "must be one of #{Constants::MATERIAL_TYPES.inspect}"
          end
        end
      end
    end
  end
end
