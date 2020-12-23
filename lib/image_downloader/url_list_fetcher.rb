# frozen_string_literal: true

require 'pathname'

module ImageDownloader
  class UrlListFetcher
    class FileNotFound < StandardError; end

    def initialize(urls_file_path, batch_size)
      @urls_file_path = Pathname.new(urls_file_path)
      @batch_size = batch_size
    end

    def perform
      raise(FileNotFound, "File #{urls_file_path} not found") unless urls_file_path.exist?

      File.open(urls_file_path) do |file|
        file.lazy.each_slice(batch_size) do |urls|
          yield(urls.map!(&:chomp))
        end
      end
    end

    private

    attr_reader :urls_file_path, :batch_size
  end
end
