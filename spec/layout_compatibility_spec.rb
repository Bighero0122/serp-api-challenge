require_relative '../lib/van_gogh_extractor'

RSpec.describe 'Layout Compatibility Testing' do
  let(:base_html) { File.read(File.join(__dir__, '..', 'files', 'van-gogh-paintings.html')) }

  describe 'original Google carousel layout' do
    it 'extracts from standard knowledge graph carousel' do
      extractor = VanGoghExtractor.new(base_html)
      result = extractor.extract_artworks
      
      expect(result[:artworks]).to be_an(Array)
      expect(result[:artworks].length).to be >= 3
      validate_artwork_structure(result[:artworks])
    end
  end

  describe 'alternative layout variations' do
    it 'handles layout variation 1 (modified selectors)' do
      modified_html = base_html.gsub('data-ved', 'data-item')
                               .gsub('kno-fb-ctx', 'knowledge-carousel')
      
      extractor = VanGoghExtractor.new(modified_html)
      result = extractor.extract_artworks
      
      expect(result[:artworks]).to be_an(Array)
      expect(result[:artworks].length).to be >= 3
      validate_artwork_structure(result[:artworks])
    end

    it 'handles layout variation 2 (different container structure)' do
      modified_html = base_html.gsub('[role="listitem"]', '[role="carousel-item"]')
                               .gsub('jscontroller', 'data-controller')
      
      extractor = VanGoghExtractor.new(modified_html)
      result = extractor.extract_artworks
      
      expect(result[:artworks]).to be_an(Array)
      expect(result[:artworks].length).to be >= 3
      validate_artwork_structure(result[:artworks])
    end
  end

  describe 'thumbnail extraction across layouts' do
    it 'extracts thumbnails without external requests' do
      extractor = VanGoghExtractor.new(base_html)
      result = extractor.extract_artworks
      
      result[:artworks].each do |artwork|
        if artwork[:image]
          expect(artwork[:image]).to start_with('data:image')
        end
      end
    end
  end

  private

  def validate_artwork_structure(artworks)
    artworks.each do |artwork|
      expect(artwork).to have_key(:name)
      expect(artwork).to have_key(:extensions)
      expect(artwork).to have_key(:link)
      expect(artwork).to have_key(:image)
    end
  end
end