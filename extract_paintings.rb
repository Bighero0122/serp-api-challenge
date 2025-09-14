require_relative 'lib/van_gogh_extractor'
require 'json'
require 'fileutils'

html_file = File.join(__dir__, 'files', 'van-gogh-paintings.html')

unless File.exist?(html_file)
  puts "Error: HTML file not found"
  exit 1
end

puts "Extracting Van Gogh paintings..."
html_content = File.read(html_file)
extractor = VanGoghExtractor.new(html_content)
result = extractor.extract_artworks

if result[:artworks].empty?
  puts "Error: No artworks extracted"
  exit 1
end

puts "\nExtracted #{result[:artworks].length} artworks:"
result[:artworks].each_with_index do |artwork, i|
  puts "#{i + 1}. #{artwork[:name]} (#{artwork[:extensions].join(', ')})"
end

FileUtils.mkdir_p('output')
File.write('output/extracted-paintings.json', JSON.pretty_generate(result))

puts "\nResults saved to output/extracted-paintings.json"