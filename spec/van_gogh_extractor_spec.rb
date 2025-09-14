require_relative '../lib/van_gogh_extractor'
require 'json'

RSpec.describe VanGoghExtractor do
  let(:html_content) { File.read(File.join(__dir__, '..', 'files', 'van-gogh-paintings.html')) }
  let(:extractor) { VanGoghExtractor.new(html_content) }
  let(:result) { extractor.extract_artworks }

  it 'extracts artworks array' do
    expect(result[:artworks]).to be_an(Array)
    expect(result[:artworks].length).to be >= 3
  end

  it 'includes required fields' do
    result[:artworks].each do |artwork|
      expect(artwork).to have_key(:name)
      expect(artwork).to have_key(:extensions)
      expect(artwork).to have_key(:link)
      expect(artwork).to have_key(:image)
    end
  end

  it 'extracts Van Gogh paintings' do
    names = result[:artworks].map { |a| a[:name].downcase }
    expect(names.any? { |name| name.include?('starry') }).to be true
  end

  it 'generates valid JSON' do
    expect { JSON.generate(result) }.not_to raise_error
  end
end