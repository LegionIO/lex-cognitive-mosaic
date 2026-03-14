# lex-cognitive-mosaic

Knowledge assembly engine for LegionIO cognitive agents. Individual tesserae (knowledge pieces) are placed into mosaics (knowledge structures) with pattern categories and grout that holds them together. Grout erodes over time and must be reinforced to prevent crumbling.

## What It Does

- Ten tessera material types: glass, stone, ceramic, metal, wood, shell, bone, crystal, clay, enamel
- Seven mosaic pattern categories: geometric, organic, abstract, narrative, symbolic, decorative, functional
- Place tesserae into mosaics with fit quality scores
- Track mosaic completeness (filled / capacity), coherence, and grout strength
- Grout decays per cycle (erode_grout!); reinforce to maintain structural integrity
- Detect crumbling mosaics (low grout) and full mosaics
- List loose (unplaced) tesserae

## Usage

```ruby
# Create tesserae
t1 = runner.create_tessera(content: 'service boundary pattern',
                             material_type: :crystal, color: 'blue', fit_quality: 0.8)
t2 = runner.create_tessera(content: 'dependency inversion principle',
                             material_type: :stone, color: 'grey', fit_quality: 0.9)

# Create a mosaic
m = runner.create_mosaic(name: 'architecture_principles',
                          pattern_category: :structural, capacity: 20)

# Place tesserae
runner.place_tessera(tessera_id: t1[:tessera][:id], mosaic_id: m[:mosaic][:id])
runner.place_tessera(tessera_id: t2[:tessera][:id], mosaic_id: m[:mosaic][:id])

# Check status
runner.mosaic_status(mosaic_id: m[:mosaic][:id])
# => { success: true, mosaic: { completeness: 0.1, grout_strength: 0.9, crumbling: false, gap_count: 18, ... } }

# List unplaced tesserae
runner.list_tesserae(loose_only: true)
```

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
