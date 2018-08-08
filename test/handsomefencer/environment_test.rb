require "test_helper"

# class Handsomefencer::EnvironmentTest < Minitest::Test
describe Handsomefencer::Environment do
  def test_that_it_has_a_version_number
    refute_nil ::Handsomefencer::Environment::VERSION
  end

  it "" do
    refute_nil ::Handsomefencer::Environment::VERSION

  end

  specify "" do
    refute_nil ::Handsomefencer::Environment::Crypto
  end
end
# end
