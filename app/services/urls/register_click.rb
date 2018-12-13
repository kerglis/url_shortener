module Urls
  class RegisterClick
    attr_reader :url, :user

    def initialize(url, user = nil)
      @url = url
      @user = user
    end

    def call
      url_click.update!(clicks: url_click.clicks.to_i + 1)
      url_click
    end

    private

    def url_click
      @url_click ||= UrlClick.where(
        url: url,
        user: user
      ).first_or_create
    end
  end
end
