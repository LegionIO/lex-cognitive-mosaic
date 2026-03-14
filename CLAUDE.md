# lex-cognitive-mosaic

**Level 3 Leaf Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`

## Purpose

Tessera and mosaic metaphor for knowledge assembly. Individual tesserae are knowledge pieces with material type, color, and fit_quality. Mosaics are named containers with a pattern category, grout strength, and capacity. Tesserae are placed into mosaics; grout holds them together but erodes over time unless reinforced. Models how knowledge fragments are assembled into coherent structures that require maintenance to hold together.

## Gem Info

- **Gem name**: `lex-cognitive-mosaic`
- **Module**: `Legion::Extensions::CognitiveMosaic`
- **Version**: `0.1.0`
- **Ruby**: `>= 3.4`
- **License**: MIT

## File Structure

```
lib/legion/extensions/cognitive_mosaic/
  version.rb
  client.rb
  helpers/
    constants.rb
    tessera.rb
    mosaic.rb
  runners/
    cognitive_mosaic.rb
```

## Key Constants

| Constant | Value | Purpose |
|---|---|---|
| `MATERIAL_TYPES` | `%i[glass stone ceramic metal wood shell bone crystal clay enamel]` | Valid tessera materials |
| `PATTERN_CATEGORIES` | `%i[geometric organic abstract narrative symbolic decorative functional]` | Valid mosaic pattern types |
| `MAX_TESSERAE` | `500` | Per-engine tessera capacity |
| `MAX_MOSAICS` | `50` | Per-engine mosaic capacity |
| `GROUT_DECAY` | `0.01` | Per-cycle grout strength reduction |
| `MIN_GROUT` | `0.05` | Minimum grout strength (floor) |
| `COMPLETENESS_LABELS` | range hash | From `:empty` to `:complete` |
| `COHERENCE_LABELS` | range hash | Mosaic structural coherence labels |

## Helpers

### `Helpers::Tessera`
Individual knowledge fragment. Has `id`, `content`, `material_type`, `color`, `fit_quality`, `placed` flag, and `mosaic_id`.

- `place!(mosaic_id)` — marks tessera as placed in a mosaic
- `placed?` — returns true if placed
- `loose?` — returns true if not placed
- `perfect_fit?` — `fit_quality >= 0.9`
- `poor_fit?` — `fit_quality <= 0.2`

### `Helpers::Mosaic`
Named container for tesserae. Has `id`, `name`, `pattern_category`, `grout_strength`, `capacity`, and `tessera_ids` array.

- `add_tessera(tessera_id, fit_quality)` — places tessera; enforces capacity
- `remove_tessera(tessera_id)` — removes tessera from mosaic
- `full?` — tessera count at capacity
- `empty?` — no tesserae placed
- `completeness` — `tessera_count / capacity.to_f`
- `erode_grout!` — reduces grout by `GROUT_DECAY` (floor at `MIN_GROUT`)
- `reinforce_grout!(amount)` — increases grout strength
- `crumbling?` — grout below a low threshold
- `completeness_label`
- `gap_count` — empty slots remaining

## Runners

Module: `Runners::CognitiveMosaic`

| Runner Method | Description |
|---|---|
| `create_tessera(content:, material_type:, color:, fit_quality:)` | Register a new tessera |
| `create_mosaic(name:, pattern_category:, capacity:)` | Create a mosaic container |
| `place_tessera(tessera_id:, mosaic_id:)` | Place a tessera into a mosaic |
| `list_tesserae(loose_only:)` | List tesserae (optionally unplaced only) |
| `list_mosaics` | All mosaics with status |
| `mosaic_status(mosaic_id:)` | Detailed status for one mosaic |

All runners return `{success: true/false, ...}` hashes.

## Integration Points

- `lex-memory`: each tessera maps to a memory trace; placing it in a mosaic represents semantic clustering
- `lex-dream`: mosaic assembly parallels the `consolidation_commit` phase of the dream cycle
- Crumbling mosaics (low grout) signal knowledge structures that need reinforcement — triggers `lex-memory` hebbian_link
- `erode_grout!` should be called periodically from `lex-tick` dormant cycles

## Development Notes

- `Client` instantiates `@mosaic_engine = Helpers::MosaicEngine.new` (engine not separately listed — the runner memoizes `@default_engine`)
- `GROUT_DECAY = 0.01` means grout reaches `MIN_GROUT = 0.05` after ~95 cycles without reinforcement
- `add_tessera` on a full mosaic returns `{error: :full}` rather than raising
- `completeness` is a ratio (0.0–1.0), not a count; a mosaic of capacity 10 with 7 tesserae has completeness 0.7
- Color is a free-form attribute (no enum) used for visual/semantic grouping
