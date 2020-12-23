# frozen_string_literal: true

Dir["#{File.dirname(__FILE__)}/lib/image_downloader/*.rb"].sort.each { |file| require file }

puts 'Starting download'

result = ImageDownloader::ListDownloader.new(ARGV[0]).perform

if result.failed_downloads.empty?
  puts 'All urls downloaded succesfully'
else
  puts 'Errors occured during download:'
  result.failed_downloads.each do |url, error_description|
    puts "#{url}   ---   #{error_description}"
  end
end
