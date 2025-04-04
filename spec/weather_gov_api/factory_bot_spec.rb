class ExampleModel
  attr_accessor :attribute_1, :attribute_2

  def initialize(attribute_1: nil, attribute_2: nil)
    @attribute_1 = attribute_1
    @attribute_2 = attribute_2
  end
end

RSpec.describe "FactoryBot Integration" do
  it "creates a valid factory" do
    example = build(:example_model)
    expect(example).to be_a(ExampleModel)
  end
end
