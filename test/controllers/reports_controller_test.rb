require "test_helper"

describe ReportsController do
  let(:report) { reports(:one) }

  it "should get index" do
    get reports_url
    must_respond_with :success
  end

  it "should get new" do
    get new_report_url
    must_respond_with :success
  end

  it "should create report" do
    assert_difference("Report.count") do
      post reports_url, params: { report: { city: @report.city, company_name: @report.company_name, conclusion: @report.conclusion, contact_person: @report.contact_person, logo_url: @report.logo_url, postalcode: @report.postalcode, street: @report.street, summary: @report.summary, title: @report.title } }
    end

    must_redirect_to report_url(Report.last)
  end

  it "should show report" do
    get report_url(@report)
    must_respond_with :success
  end

  it "should get edit" do
    get edit_report_url(@report)
    must_respond_with :success
  end

  it "should update report" do
    patch report_url(@report), params: { report: { city: @report.city, company_name: @report.company_name, conclusion: @report.conclusion, contact_person: @report.contact_person, logo_url: @report.logo_url, postalcode: @report.postalcode, street: @report.street, summary: @report.summary, title: @report.title } }
    must_redirect_to report_url(report)
  end

  it "should destroy report" do
    assert_difference("Report.count", -1) do
      delete report_url(@report)
    end

    must_redirect_to reports_url
  end
end
