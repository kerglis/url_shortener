FactoryBot.define do
  factory :url do
    user
    url_long { Faker::Internet.url }
  end
end
