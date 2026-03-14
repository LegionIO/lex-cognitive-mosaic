# frozen_string_literal: true

require_relative 'lib/legion/extensions/cognitive_mosaic/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-cognitive-mosaic'
  spec.version       = Legion::Extensions::CognitiveMosaic::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']
  spec.license       = 'MIT'

  spec.summary       = 'Cognitive mosaic LEX — assembling fragments into coherent wholes'
  spec.description   = 'Models mosaic assembly: tesserae (individual cognitive fragments) placed into ' \
                       'mosaics with pattern categories, grout strength for cohesion, coherence ' \
                       'scoring, gap detection for missing pieces.'
  spec.homepage      = 'https://github.com/LegionIO/lex-cognitive-mosaic'

  spec.required_ruby_version = '>= 3.4'

  spec.metadata['homepage_uri']      = spec.homepage
  spec.metadata['source_code_uri']   = spec.homepage
  spec.metadata['documentation_uri'] = "#{spec.homepage}#readme"
  spec.metadata['changelog_uri']     = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['bug_tracker_uri']   = "#{spec.homepage}/issues"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(test|spec|features)/}) }
  end

  spec.require_paths = ['lib']
end
