require "application_system_test_case"

describe "ReportParts", :system do
  let(:report_part) { report_parts(:one) }

  it "visiting the index" do
    visit report_parts_url
    assert_selector "h1", text: "Report Parts"
  end

  it "creating a Report part" do
    visit report_parts_url
    click_on "New Report Part"

    fill_in "Customtargets", with: @report_part.customtargets
    fill_in "Description", with: @report_part.description
    fill_in "Index", with: @report_part.index
    fill_in "Rating", with: @report_part.rating
    fill_in "Recommendation", with: @report_part.recommendation
    fill_in "Severity", with: @report_part.severity
    fill_in "Title", with: @report_part.title
    fill_in "Type", with: @report_part.type
    click_on "Create Report part"

    assert_text "Report part was successfully created"
    click_on "Back"
  end

  it "updating a Report part" do
    visit report_parts_url
    click_on "Edit", match: :first

    fill_in "Customtargets", with: @report_part.customtargets
    fill_in "Description", with: @report_part.description
    fill_in "Index", with: @report_part.index
    fill_in "Rating", with: @report_part.rating
    fill_in "Recommendation", with: @report_part.recommendation
    fill_in "Severity", with: @report_part.severity
    fill_in "Title", with: @report_part.title
    fill_in "Type", with: @report_part.type
    click_on "Update Report part"

    assert_text "Report part was successfully updated"
    click_on "Back"
  end

  it "destroying a Report part" do
    visit report_parts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Report part was successfully destroyed"
  end
end
