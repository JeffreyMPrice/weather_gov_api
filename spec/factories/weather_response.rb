# frozen_string_literal: true

FactoryBot.define do
  factory :weather_response, class: Hash do
    transient do
      temperature { 22.8 }
    end

    initialize_with do
      {
        "properties" => {
          "temperature" => { "value" => temperature,
                             "unitCode" => "unit:degC" }
        }
      }.stringify_keys
    end

    trait :cold_weather do
      temperature { -5.0 }
    end

    trait :hot_weather do
      temperature { 35.0 }
    end
  end
end
