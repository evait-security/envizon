require "application_system_test_case"

describe "Issues", :system do
  let(:issue) { issues(:one) }

  it "visiting the index" do
    visit issues_url
    assert_selector "h1", text: "Issues"
  end

  it "creating a Issue" do
    visit issues_url
    click_on "New Issue"

    fill_in "Customtargets", with: @issue.customtargets
    fill_in "Description", with: @issue.description
    fill_in "Index", with: @issue.index
    fill_in "Rating", with: @issue.rating
    fill_in "Recommendation", with: @issue.recommendation
    fill_in "Severity", with: @issue.severity
    fill_in "Title", with: @issue.title
    fill_in "Type", with: @issue.type
    click_on "Create Issue"

    assert_text "Issue was successfully created"
    click_on "Back"
  end

  it "updating a Issue" do
    visit issues_url
    click_on "Edit", match: :first

    fill_in "Customtargets", with: @issue.customtargets
    fill_in "Description", with: @issue.description
    fill_in "Index", with: @issue.index
    fill_in "Rating", with: @issue.rating
    fill_in "Recommendation", with: @issue.recommendation
    fill_in "Severity", with: @issue.severity
    fill_in "Title", with: @issue.title
    fill_in "Type", with: @issue.type
    click_on "Update Issue"

    assert_text "Issue was successfully updated"
    click_on "Back"
  end

  it "destroying a Issue" do
    visit issues_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Issue was successfully destroyed"
  end
end
