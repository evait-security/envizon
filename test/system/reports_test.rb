require "application_system_test_case"

describe "Reports", :system do
  let(:report) { reports(:one) }

  it "visiting the index" do
    visit reports_url
    assert_selector "h1", text: "Reports"
  end

  it "creating a Report" do
    visit reports_url
    click_on "New Report"

    fill_in "City", with: @report.city
    fill_in "Company name", with: @report.company_name
    fill_in "Conclusion", with: @report.conclusion
    fill_in "Contact person", with: @report.contact_person
    fill_in "Logo url", with: @report.logo_url
    fill_in "Postalcode", with: @report.postalcode
    fill_in "Street", with: @report.street
    fill_in "Summary", with: @report.summary
    fill_in "Title", with: @report.title
    click_on "Create Report"

    assert_text "Report was successfully created"
    click_on "Back"
  end

  it "updating a Report" do
    visit reports_url
    click_on "Edit", match: :first

    fill_in "City", with: @report.city
    fill_in "Company name", with: @report.company_name
    fill_in "Conclusion", with: @report.conclusion
    fill_in "Contact person", with: @report.contact_person
    fill_in "Logo url", with: @report.logo_url
    fill_in "Postalcode", with: @report.postalcode
    fill_in "Street", with: @report.street
    fill_in "Summary", with: @report.summary
    fill_in "Title", with: @report.title
    click_on "Update Report"

    assert_text "Report was successfully updated"
    click_on "Back"
  end

  it "destroying a Report" do
    visit reports_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Report was successfully destroyed"
  end
end
