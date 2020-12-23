# frozen_string_literal: true

require_relative '../spec_helper'

describe ImageDownloader::UrlDownloader do
  subject(:url_downloader) do
    ImageDownloader::UrlDownloader.new(url)
  end

  describe 'Downloads image' do
    let!(:image) { File.open(File.expand_path('./spec/support/1x1.png')) }
    let!(:url) { 'https://via.placeholder.com/1x1.png' }

    before do
      stub_request(:get, url)
        .to_return(status: 200, body: image, headers: {})
    end

    it 'Image is downloaded to destination folder' do
      expect { url_downloader.perform }
        .to change { Dir["#{ImageDownloader::UrlDownloader::DOWNLOAD_PATH}/*.png"].count }
        .from(0).to(1)
    end
  end
end
