class RedirectController < ApplicationController
  before_action :resolve_url

  def show
    redirect_to @url.url_long and return if @url

    @random_url =
      Url.order('RANDOM()').first&.url_short ||
      'we_dont_have_any_urls_yet'
  end

  private

  def resolve_url
    @url = Url.find_by(url_short: url_string)
  end

  def url_string
    @url_string ||= params[:all]
  end
end
