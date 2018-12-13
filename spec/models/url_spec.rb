require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'associations' do
    it do
      aggregate_failures do
        is_expected.to belong_to :user
        is_expected.to have_many :url_clicks
      end
    end
  end

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
      let(:url) { build :url, manual_url_short: manual_url_short }
      subject { url.valid? }

      context 'when valid' do
        let(:manual_url_short) { ' my_cool_url ' }
        it { is_expected.to be true }
      end

      context 'when invalid' do
        let(:manual_url_short) { '--- my_cool_url' }
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
          expect(url.url_short).to eq 'my_cool_url'
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

  describe 'update url_short through manual_url_short' do
    let!(:url1) { create :url, url_short: 'my_cool_url' }
    let!(:url2) { create :url, url_short: 'my_not_so_cool_url' }

    before { url2.update_attributes(manual_url_short: new_url_short) }

    context 'when valid' do
      let(:new_url_short) { 'so_very_cool_url' }

      it do
        aggregate_failures do
          expect(url2).to be_valid
          expect(url2.url_short).to eq new_url_short
        end
      end
    end
  end

  describe 'scopes' do
    describe '.with_click_summary' do
      let!(:url1) { create :url }
      let!(:url2) { create :url }
      let!(:url3) { create :url }
      let!(:user1) { create :user }
      let!(:user2) { create :user }

      subject do
        described_class
          .with_click_summary
          .order(:id)
          .map { |u| [u.id, u.click_summary] }
      end

      context 'when no clicks' do
        it do
          is_expected.to eq [
            [url1.id, nil],
            [url2.id, nil],
            [url3.id, nil]
          ]
        end
      end

      context 'when some clicks' do
        before do
          Urls::RegisterClick.new(url1).call
          Urls::RegisterClick.new(url1, user1).call
          Urls::RegisterClick.new(url1, user2).call
          Urls::RegisterClick.new(url2).call
          Urls::RegisterClick.new(url2).call
        end

        it do
          is_expected.to eq [
            [url1.id, 3],
            [url2.id, 2],
            [url3.id, nil]
          ]
        end
      end
    end
  end
end
