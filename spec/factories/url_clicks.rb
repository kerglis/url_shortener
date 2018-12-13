FactoryBot.define do
  factory :url_click do
    url
    user
    clicks { 1 }
  end
end
