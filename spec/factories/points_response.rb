# frozen_string_literal: true

FactoryBot.define do
  factory :points_response, class: Hash do
    initialize_with { attributes.stringify_keys }
    properties do
      {
        "observationStations" => "https://api.weather.gov/gridpoints/TOP/31,80/stations"
      }
    end
  end
end
