# frozen_string_literal: true

require 'securerandom'

require_relative 'cognitive_mosaic/version'
require_relative 'cognitive_mosaic/helpers/constants'
require_relative 'cognitive_mosaic/helpers/tessera'
require_relative 'cognitive_mosaic/helpers/mosaic'
require_relative 'cognitive_mosaic/helpers/mosaic_engine'
require_relative 'cognitive_mosaic/runners/cognitive_mosaic'
require_relative 'cognitive_mosaic/client'

module Legion
  module Extensions
    module CognitiveMosaic
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
