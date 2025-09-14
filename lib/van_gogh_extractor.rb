require 'nokogiri'
require 'json'

class VanGoghExtractor
  def initialize(html_content)
    @doc = Nokogiri::HTML(html_content)
  end

  def extract_artworks
    # TODO: Implement extraction logic
    { artworks: [] }
  end
end