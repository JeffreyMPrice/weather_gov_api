FactoryBot.define do
  factory :points_response, class: Hash do
    transient do
      grid_x { 31 }
      grid_y { 80 }
      grid_id { "TOP" }
    end

    initialize_with do
      {
        "properties" => {
          "observationStations" => "https://api.weather.gov/gridpoints/#{grid_id}/#{grid_x},#{grid_y}/stations"
        }
      }.stringify_keys
    end

    trait :invalid_coordinates do
      initialize_with do
        {
          "detail" => "Invalid Parameter"
        }.stringify_keys
      end
    end

    trait :non_us_coordinates do
      initialize_with do
        {
          "detail" => "Data Unavailable For Requested Point"
        }.stringify_keys
      end
    end
  end
end
