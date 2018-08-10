require "test_helper"

describe Handsomefencer::Environment do

  specify "must have version number" do
    refute_nil ::Handsomefencer::Environment::VERSION
  end

  specify "must have Crypto class" do
    refute_nil ::Handsomefencer::Environment::Crypto
  end
end
