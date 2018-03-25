require "test_helper"

describe SavedScan do
  let(:saved_scan) { SavedScan.new }

  it "must be valid" do
    value(saved_scan).must_be :valid?
  end
end
