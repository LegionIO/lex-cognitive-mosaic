# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveMosaic
      module Helpers
        class Mosaic
          attr_reader :id, :name, :pattern_category, :tessera_ids,
                      :capacity, :created_at
          attr_accessor :grout_strength

          def initialize(name:, pattern_category:, capacity: 50, grout_strength: nil)
            validate_pattern!(pattern_category)
            @id               = SecureRandom.uuid
            @name             = name.to_s
            @pattern_category = pattern_category.to_sym
            @tessera_ids      = []
            @capacity         = capacity.to_i.clamp(1, 500)
            @grout_strength   = (grout_strength || 0.8).to_f.clamp(0.0, 1.0).round(10)
            @created_at       = Time.now.utc
          end

          def add_tessera(tessera_id)
            return false if @tessera_ids.include?(tessera_id)
            return false if full?

            @tessera_ids << tessera_id
            true
          end

          def remove_tessera(tessera_id)
            @tessera_ids.delete(tessera_id) ? true : false
          end

          def size
            @tessera_ids.size
          end

          def full?
            @tessera_ids.size >= @capacity
          end

          def empty?
            @tessera_ids.empty?
          end

          def completeness
            return 0.0 if @capacity.zero?

            (@tessera_ids.size.to_f / @capacity).clamp(0.0, 1.0).round(10)
          end

          def erode_grout!(rate: Constants::GROUT_DECAY)
            @grout_strength = (@grout_strength - rate.abs).clamp(0.0, 1.0).round(10)
            self
          end

          def reinforce_grout!(boost: 0.1)
            @grout_strength = (@grout_strength + boost.abs).clamp(0.0, 1.0).round(10)
            self
          end

          def crumbling?
            @grout_strength < 0.2
          end

          def completeness_label
            Constants.label_for(Constants::COMPLETENESS_LABELS, completeness)
          end

          def gap_count
            @capacity - @tessera_ids.size
          end

          def to_h
            {
              id:                @id,
              name:              @name,
              pattern_category:  @pattern_category,
              tessera_ids:       @tessera_ids.dup,
              size:              size,
              capacity:          @capacity,
              completeness:      completeness,
              completeness_label: completeness_label,
              grout_strength:    @grout_strength,
              gap_count:         gap_count,
              full:              full?,
              empty:             empty?,
              crumbling:         crumbling?,
              created_at:        @created_at
            }
          end

          private

          def validate_pattern!(val)
            return if Constants::PATTERN_CATEGORIES.include?(val.to_sym)

            raise ArgumentError,
                  "unknown pattern category: #{val.inspect}; " \
                  "must be one of #{Constants::PATTERN_CATEGORIES.inspect}"
          end
        end
      end
    end
  end
end
