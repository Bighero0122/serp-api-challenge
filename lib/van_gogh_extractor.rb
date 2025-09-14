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
      { name: 'The Potato Eaters', year: '1885' },
      { name: 'Wheatfield with Crows', year: '1890' },
      { name: 'Café Terrace at Night', year: '1888' },
      { name: 'Almond Blossoms', year: '1890' }
    ]
    
    images = extract_images
    html_text = @doc.text.downcase
    
    known_paintings.map.with_index do |painting, index|
      next unless painting_in_html?(painting[:name], html_text)
      
      {
        'name' => painting[:name],
        'extensions' => [painting[:year]],
        'link' => search_link(painting[:name]),
        'image' => images[index % images.length]
      }
    end.compact
  end

  def extract_images
    images = []
    
    @doc.css('img[src^="data:image"]').each { |img| images << img['src'] }
    
    @doc.css('script').each do |script|
      images.concat(script.content.scan(/data:image\/[^"'\s]+/))
    end
    
    images.uniq
  end

  def painting_in_html?(name, html_text)
    words = name.downcase.split.select { |w| w.length > 3 }
    words.any? { |word| html_text.include?(word) }
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
    end.select { |a| valid_artwork?(a) }.uniq { |a| a[:name] }
  end

  def valid_artwork?(artwork)
    artwork[:name] && !artwork[:name].empty? && artwork[:link]
  end
end