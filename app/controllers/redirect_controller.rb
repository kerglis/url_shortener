class RedirectController < ApplicationController
  before_action :resolve_url

  def index
    if @url
      @url.register_click!(current_user)
      redirect_to @url.url_long and return
    end

    @random_url =
      Url.order(Arel.sql('RANDOM()')).first&.url_short ||
      'we_dont_have_any_urls_yet'

    render :index, status: url_string.present? ? 404 : 200
  end

  private

  def resolve_url
    @url = Url.find_by(url_short: url_string)
  end

  def url_string
    @url_string ||= params[:all]
  end
end
