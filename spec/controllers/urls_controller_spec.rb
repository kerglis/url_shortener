require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  render_views

  let!(:user) { create :user }

  before { sign_in(user) }

  describe 'statistics' do
    subject { get :statistics }

    context 'when no URLs available' do
      it do
        subject
        aggregate_failures do
          expect(response.status).to eq 200
          expect(response.body).to include 'No URLs with statistics available'
        end
      end
    end

    context 'with urls' do
      let!(:url1) { create :url, url_long: 'http://apple.com' }
      let!(:url2) { create :url, url_long: 'http://ibm.com' }

      before do
        Urls::RegisterClick.new(url1).call
        Urls::RegisterClick.new(url1, user).call
        Urls::RegisterClick.new(url2, user).call
        Urls::RegisterClick.new(url2, user).call
        Urls::RegisterClick.new(url2).call
      end

      it do
        subject
        aggregate_failures do
          expect(response.status).to eq 200
          expect(response.body.squish).to match %r{<td> 1. </td> <td> http://ibm.com </td>}
          expect(response.body.squish).to match %r{<td> 2. </td> <td> http://apple.com </td>}
        end
      end
    end
  end
end
