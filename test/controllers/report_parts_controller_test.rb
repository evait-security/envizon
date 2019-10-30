require "test_helper"

describe ReportPartsController do
  let(:report_part) { report_parts(:one) }

  it "should get index" do
    get report_parts_url
    must_respond_with :success
  end

  it "should get new" do
    get new_report_part_url
    must_respond_with :success
  end

  it "should create report_part" do
    assert_difference("ReportPart.count") do
      post report_parts_url, params: { report_part: { customtargets: @report_part.customtargets, description: @report_part.description, index: @report_part.index, rating: @report_part.rating, recommendation: @report_part.recommendation, severity: @report_part.severity, title: @report_part.title, type: @report_part.type } }
    end

    must_redirect_to report_part_url(ReportPart.last)
  end

  it "should show report_part" do
    get report_part_url(@report_part)
    must_respond_with :success
  end

  it "should get edit" do
    get edit_report_part_url(@report_part)
    must_respond_with :success
  end

  it "should update report_part" do
    patch report_part_url(@report_part), params: { report_part: { customtargets: @report_part.customtargets, description: @report_part.description, index: @report_part.index, rating: @report_part.rating, recommendation: @report_part.recommendation, severity: @report_part.severity, title: @report_part.title, type: @report_part.type } }
    must_redirect_to report_part_url(report_part)
  end

  it "should destroy report_part" do
    assert_difference("ReportPart.count", -1) do
      delete report_part_url(@report_part)
    end

    must_redirect_to report_parts_url
  end
end
