require 'nokogiri'
require 'json'
require 'uri'

class VanGoghExtractor
  def initialize(html_content)
    @doc = Nokogiri::HTML(html_content)
  end

  def extract_artworks
    artworks = extract_from_json
    { artworks: format_artworks(artworks) }
  end

  private

  def extract_from_json
    @doc.css('script').each do |script|
      content = script.content
      next unless content.include?('knowledge_graph')
      
      if match = content.match(/"artworks":\s*(\[.*?\])/m)
        begin
          return JSON.parse(match[1])
        rescue JSON::ParserError
          next
        end
      end
    end
    []
  end

  def format_artworks(raw_artworks)
    raw_artworks.map do |artwork|
      {
        name: artwork['name'],
        extensions: artwork['extensions'] || [],
        link: artwork['link'],
        image: artwork['image']
      }
    end
  end
end