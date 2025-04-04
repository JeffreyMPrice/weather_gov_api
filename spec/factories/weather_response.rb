# frozen_string_literal: true

FactoryBot.define do
  factory :weather_response, class: Hash do
    initialize_with { attributes.stringify_keys }
    properties do
      {
        "temperature" => {
          "value" => 22.8,
          "unitCode" => "unit:degC"
        }
      }
    end
  end
end
