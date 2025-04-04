# frozen_string_literal: true

class ExampleModel
  attr_accessor :attribute1, :attribute2

  def initialize(attribute1: nil, attribute2: nil)
    @attribute1 = attribute1
    @attribute2 = attribute2
  end
end

RSpec.describe "ExampleModel" do
  it "creates a valid factory" do
    example = build(:example_model)
    expect(example).to be_a(ExampleModel)
  end
end
