# frozen_string_literal: true

require_relative '../spec_helper'

describe ImageDownloader::ListDownloader do
  subject(:list_downloader) do
    ImageDownloader::ListDownloader.new(urls_file_path)
  end

  let!(:urls_file_path) { './spec/support/urls.txt' }

  describe 'When no exceptions raised' do
    it 'Calls perform on two downloaders' do
      first_downloader = instance_double(ImageDownloader::UrlDownloader)
      allow(ImageDownloader::UrlDownloader)
        .to receive(:new).with('https://via.placeholder.com/1x1.jpg')
                         .and_return(first_downloader)

      second_downloader = instance_double(ImageDownloader::UrlDownloader)
      allow(ImageDownloader::UrlDownloader)
        .to receive(:new).with('https://via.placeholder.com/1')
                         .and_return(second_downloader)

      expect(first_downloader).to receive(:perform)
      expect(second_downloader).to receive(:perform)

      list_downloader.perform
    end
  end

  describe 'When Down::NotFound exception is raised' do
    it 'Adds url to failed downloads and continues iteration' do
      first_downloader = instance_double(ImageDownloader::UrlDownloader)
      allow(first_downloader)
        .to receive(:perform).and_raise(Down::NotFound, 'Requested url not found')

      allow(ImageDownloader::UrlDownloader)
        .to receive(:new).with('https://via.placeholder.com/1x1.jpg')
                         .and_return(first_downloader)

      second_downloader = instance_double(ImageDownloader::UrlDownloader)
      expect(second_downloader).to receive(:perform)
      allow(ImageDownloader::UrlDownloader)
        .to receive(:new).with('https://via.placeholder.com/1')
                         .and_return(second_downloader)

      result = list_downloader.perform

      expect(result.failed_downloads)
        .to eq({ 'https://via.placeholder.com/1x1.jpg' => 'Requested url not found' })
    end
  end
end
