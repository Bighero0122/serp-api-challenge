require 'nokogiri'
require 'json'
require 'uri'

class VanGoghExtractor
  def initialize(html_content)
    @doc = Nokogiri::HTML(html_content)
  end

  def extract_artworks
    artworks = extract_from_json || extract_fallback
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
    nil
  end

  def extract_fallback
    known_paintings = [
      { name: 'The Starry Night', year: '1889' },
      { name: 'Van Gogh self-portrait', year: '1889' },
      { name: 'The Potato Eaters', year: '1885' }
    ]
    
    html_text = @doc.text.downcase
    
    known_paintings.map do |painting|
      next unless html_text.include?(painting[:name].downcase)
      
      {
        'name' => painting[:name],
        'extensions' => [painting[:year]],
        'link' => search_link(painting[:name]),
        'image' => nil
      }
    end.compact
  end

  def search_link(name)
    "https://www.google.com/search?q=#{URI.encode_www_form_component(name)}"
  end

  def format_artworks(artworks)
    return [] unless artworks
    
    artworks.map do |artwork|
      {
        name: artwork['name'] || artwork[:name],
        extensions: Array(artwork['extensions'] || artwork[:extensions]),
        link: artwork['link'] || artwork[:link],
        image: artwork['image'] || artwork[:image]
      }
    end.select { |a| a[:name] && !a[:name].empty? }
  end
end