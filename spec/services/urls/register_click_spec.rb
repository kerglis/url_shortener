require 'rails_helper'

RSpec.describe Urls::RegisterClick, type: :model do
  let(:service) { described_class.new(url, user) }
  let!(:url) { create :url }

  shared_examples 'url clicks' do
    let(:url_click) { service.call }
    subject! { url_click }

    it do
      aggregate_failures do
        is_expected.to be_present
        expect(url_click.reload.clicks).to eq 1
      end
    end

    context 'when call again' do
      before { service.call }
      it { expect(url_click.reload.clicks).to eq 2 }
    end
  end

  context 'with no user' do
    let!(:user) { nil }
    it_behaves_like 'url clicks'
  end

  context 'with user' do
    let!(:user) { create :user }
    it_behaves_like 'url clicks'
  end
end
