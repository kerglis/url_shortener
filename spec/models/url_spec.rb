require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'validations' do
    it do
      aggregate_failures do
        is_expected.to validate_presence_of :user
        is_expected.to validate_presence_of :url_long
      end
    end

    describe 'url_long format' do
      let(:url) { build :url, url_long: url_long }
      subject { url.valid? }

      context 'when valid' do
        let(:url_long) { ' http://www.apple.com/ ' }
        it { is_expected.to be true }
      end

      context 'when invalid' do
        let(:url_long) { 'ht://www. apple.com' }
        it { is_expected.to be false }
      end
    end

    describe 'url_short format' do
      let(:url) { build :url, url_short: url_short }
      subject { url.valid? }

      context 'when valid' do
        let(:url_short) { ' my_cool_url ' }
        it { is_expected.to be true }
      end
      context 'when invalid' do
        let(:url_short) { '--- my_cool_url' }
        it do
          aggregate_failures do
            is_expected.to be false
            expect(url.errors[:url_short]).to eq ['only allows alpha-numeric and _']
          end
        end
      end
    end

    describe 'url_short uniqueness' do
      let!(:url) { create :url, url_short: 'my_cool_url' }
      let(:url2) do
        # add all CAPS
        build :url, url_short: 'MY_COOL_URL'
      end

      it do
        aggregate_failures do
          expect(url2).to_not be_valid
          expect(url2.errors[:url_short]).to eq ['has already been taken']
        end
      end
    end
  end

  describe '#generate_url_short' do
    let(:url) { build :url }

    it 'generates `url_short` before validation' do
      aggregate_failures do
        expect(url.url_short).to be_blank
        url.valid?
        expect(url.url_short).to be_present
        expect(url.url_short.size).to eq Url::URL_SHORT_LENGTH
      end
    end
  end
end