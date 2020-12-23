# frozen_string_literal: true

require_relative '../spec_helper'

describe ImageDownloader::UrlListFetcher do
  subject(:fetcher) do
    ImageDownloader::UrlListFetcher.new(urls_file_path, batch_size)
  end

  let!(:batch_size) { 1 }

  describe 'When url list file exists' do
    let!(:urls_file_path) { './spec/support/urls.txt' }

    it 'Calls block with url as an argument' do
      block_args = []
      fetcher.perform { |url| block_args << url }
      expect(block_args).to eq(
        [
          ['https://via.placeholder.com/1x1.jpg'],
          ['https://via.placeholder.com/1']
        ]
      )
    end
  end

  describe 'When url list not found' do
    let!(:urls_file_path) { '' }

    it 'Raises FileNotFound error' do
      expect { fetcher.perform }.to raise_error(ImageDownloader::UrlListFetcher::FileNotFound)
    end
  end

  describe 'When block not given' do
    let!(:urls_file_path) { './spec/support/urls.txt' }

    it 'Raises LocalJumpError error' do
      expect { fetcher.perform }.to raise_error(LocalJumpError)
    end
  end
end
