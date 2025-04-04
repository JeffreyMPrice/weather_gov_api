# frozen_string_literal: true

FactoryBot.define do
  factory :stations_response, class: Hash do
    initialize_with { attributes.stringify_keys }
    features do
      [
        {
          "properties" => {
            "stationIdentifier" => "KTOP",
            "name" => "TOPEKA FORBES FIELD"
          }
        }
      ]
    end
  end
end
