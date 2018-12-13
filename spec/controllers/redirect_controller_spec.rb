require 'rails_helper'

RSpec.describe RedirectController, type: :controller do
  render_views

  describe 'routing' do
    subject { get :index, params: { all: params } }

    context 'empty_path' do
      let(:params) { '' }

      it do
        subject
        aggregate_failures do
          expect(response).to render_template(:index)
          expect(response.body).to include 'we_dont_have_any_urls_yet'
          expect(response.status).to eq 200
        end
      end
    end

    context 'unfound path' do
      let(:params) { 'not_found' }

      it do
        subject
        aggregate_failures do
          expect(response).to render_template(:index)
          expect(response.body).to include 'Please enter url-shortcut into your addressbar!'
          expect(response.status).to eq 404
        end
      end
    end

    context 'found path' do
      let(:params) { 'apple' }
      let!(:url) do
        create :url,
               url_long: 'http://www.example.com',
               url_short: 'apple'
      end

      it 'redirect to `url_long`' do
        subject
        aggregate_failures do
          expect(response.status).to eq 302
          expect(response).to redirect_to('http://www.example.com')
        end
      end
    end
  end
end
