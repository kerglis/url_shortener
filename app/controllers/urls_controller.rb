class UrlsController < ApplicationController
  inherit_resources

  before_action :authenticate_user!

  def create
    @url = Url.new(permitted_params[:url])
    @url.user = current_user
    create! { collection_url }
  end

  def update
    update! { collection_url }
  end

  def show
    redirect_to collection_url
  end

  private

  def permitted_params
    params.permit(url: %i[url_long manual_url_short])
  end

  def collection
    @urls ||= current_user.urls.with_click_summary
  end
end
