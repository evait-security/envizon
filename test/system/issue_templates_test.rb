require "application_system_test_case"

describe "IssueTemplates", :system do
  let(:issue_template) { issue_templates(:one) }

  it "visiting the index" do
    visit issue_templates_url
    assert_selector "h1", text: "Issue Templates"
  end

  it "creating a Issue template" do
    visit issue_templates_url
    click_on "New Issue Template"

    fill_in "Description", with: @issue_template.description
    fill_in "Rating", with: @issue_template.rating
    fill_in "Recommendation", with: @issue_template.recommendation
    fill_in "Severity", with: @issue_template.severity
    fill_in "Title", with: @issue_template.title
    click_on "Create Issue template"

    assert_text "Issue template was successfully created"
    click_on "Back"
  end

  it "updating a Issue template" do
    visit issue_templates_url
    click_on "Edit", match: :first

    fill_in "Description", with: @issue_template.description
    fill_in "Rating", with: @issue_template.rating
    fill_in "Recommendation", with: @issue_template.recommendation
    fill_in "Severity", with: @issue_template.severity
    fill_in "Title", with: @issue_template.title
    click_on "Update Issue template"

    assert_text "Issue template was successfully updated"
    click_on "Back"
  end

  it "destroying a Issue template" do
    visit issue_templates_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Issue template was successfully destroyed"
  end
end
