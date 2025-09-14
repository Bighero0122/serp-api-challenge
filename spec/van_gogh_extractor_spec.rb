require_relative '../lib/van_gogh_extractor'

RSpec.describe VanGoghExtractor do
  let(:html_content) { '<html><body>test</body></html>' }
  let(:extractor) { VanGoghExtractor.new(html_content) }

  describe '#extract_artworks' do
    it 'returns hash with artworks array' do
      result = extractor.extract_artworks
      expect(result).to have_key(:artworks)
      expect(result[:artworks]).to be_an(Array)
    end
  end
end