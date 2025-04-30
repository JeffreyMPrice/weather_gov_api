FactoryBot.define do
  factory :stations_response, class: Hash do
    transient do
      station_identifier { "KTOP" }
      station_name { "Topeka, KS" }
    end

    initialize_with do
      {
        "features" => [
          {
            "properties" => {
              "stationIdentifier" => station_identifier,
              "name" => station_name
            }
          }
        ]
      }.stringify_keys
    end

    trait :no_stations do
      initialize_with do
        {
          "features" => []
        }.stringify_keys
      end
    end
  end
end
