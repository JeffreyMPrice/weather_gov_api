RSpec.shared_context "with successful points request" do
  let(:latitude) { raise "latitude must be defined in the including context" }
  let(:longitude) { raise "longitude must be defined in the including context" }
  # Provide defaults or raise if not overridden
  let(:grid_id) do
    raise "grid_id must be defined in the including context"
  end
  let(:grid_x) { 32 }
  let(:grid_y) { 81 }
  let(:points_response_body) do
    build(:points_response, grid_id: grid_id, grid_x: grid_x, grid_y: grid_y)
  end

  before do
    # Assuming 'stubs' and 'default_headers' are available
    stubs.get("/points/#{latitude},#{longitude}") do
      [200, default_headers, points_response_body.to_json]
    end
  end
end
