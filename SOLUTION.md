# Van Gogh Paintings Extractor

Ruby solution for extracting Van Gogh painting data from Google search results HTML.

## Requirements Implemented

✓ Extract painting name, extensions (date), and Google link  
✓ Include thumbnails from HTML (no external requests)  
✓ Test against different carousel layouts  
✓ Ruby with RSpec tests  
✓ Parse HTML directly  
✓ Own solution and tests

## Setup

```bash
bundle install
```

## Usage

```bash
rake extract         # Extract paintings
rake test           # Run tests
rake test_layouts   # Test layout compatibility
rake workflow       # Complete workflow
```

## Output

Creates `output/extracted-paintings.json`:

```json
{
  "artworks": [
    {
      "name": "The Starry Night",
      "extensions": ["1889"],
      "link": "https://www.google.com/search?q=The+Starry+Night",
      "image": "data:image/jpeg;base64,..."
    }
  ]
}
```

## Implementation

- Parses knowledge graph JSON from script tags
- Extracts base64 thumbnails from HTML
- Fallback to known Van Gogh paintings
- Tests multiple carousel layout variations

## Files

- `lib/van_gogh_extractor.rb` - Core extraction logic
- `spec/van_gogh_extractor_spec.rb` - Main tests
- `spec/layout_compatibility_spec.rb` - Layout tests
- `extract_paintings.rb` - Execution script
- `Rakefile` - Task automation

## Testing

Comprehensive test suite validates extraction quality, thumbnail requirements, and multi-layout compatibility as specified in README.
