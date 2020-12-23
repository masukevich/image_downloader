# frozen_string_literal: true

require 'down'

module ImageDownloader
  class UrlDownloader
    TIMEOUT_PERIOD = 10
    MAX_SIZE = 5 # In MB
    MAX_REDIRECTS = 2
    OPEN_TIMEOUT = 5
    READ_TIMEOUT = 10
    DOWNLOAD_PATH = "#{Dir.pwd}/images"

    def initialize(url)
      @url = url
    end

    def perform
      Down.download(
        url,
        max_size: MAX_SIZE * 1024 * 1024,
        max_redirects: MAX_REDIRECTS,
        open_timeout: OPEN_TIMEOUT,
        read_timeout: READ_TIMEOUT,
        destination: DOWNLOAD_PATH
      )
    end

    private

    attr_reader :url
  end
end
