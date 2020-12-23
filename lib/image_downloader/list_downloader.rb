# frozen_string_literal: true

require 'down'

module ImageDownloader
  class ListDownloader
    attr_reader :failed_downloads

    DOWNLOAD_ERRORS = [
      Down::TooLarge,
      Down::InvalidUrl,
      Down::TooManyRedirects,
      Down::ResponseError,
      Down::ClientError,
      Down::NotFound,
      Down::ServerError,
      Down::ConnectionError,
      Down::TimeoutError,
      Down::SSLError
    ].freeze

    BATCH_SIZE = 5

    def initialize(urls_file_path)
      @urls_file_path = urls_file_path
      @failed_downloads = {}
    end

    def perform
      FileUtils.mkdir_p(UrlDownloader::DOWNLOAD_PATH) unless Dir.exist?(UrlDownloader::DOWNLOAD_PATH)

      UrlListFetcher.new(urls_file_path, BATCH_SIZE).perform { |urls| process_urls(urls) }

      self
    end

    private

    attr_writer :failed_downloads
    attr_reader :urls_file_path

    def process_urls(urls)
      threads = urls.each_with_object([]) do |url, threads_batch|
        threads_batch << Thread.new do
          thread_download_fail = Thread.current[:thread_download_fail] = {}
          download_file(url, thread_download_fail)
        end
      end

      threads.each do |thread|
        thread.join
        failed_downloads.merge!(thread[:thread_download_fail])
      end
    end

    def download_file(url, thread_download_fail)
      UrlDownloader.new(url).perform
    rescue *DOWNLOAD_ERRORS => e
      thread_download_fail[url] = e.message
    end
  end
end
