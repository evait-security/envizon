require "application_system_test_case"

describe "IssueGroups", :system do
  let(:issue_group) { issue_groups(:one) }

  it "visiting the index" do
    visit issue_groups_url
    assert_selector "h1", text: "Issue Groups"
  end

  it "creating a Issue group" do
    visit issue_groups_url
    click_on "New Issue Group"

    fill_in "Customtargets", with: @issue_group.customtargets
    fill_in "Description", with: @issue_group.description
    fill_in "Index", with: @issue_group.index
    fill_in "Rating", with: @issue_group.rating
    fill_in "Recommendation", with: @issue_group.recommendation
    fill_in "Severity", with: @issue_group.severity
    fill_in "Title", with: @issue_group.title
    fill_in "Type", with: @issue_group.type
    click_on "Create Issue group"

    assert_text "Issue group was successfully created"
    click_on "Back"
  end

  it "updating a Issue group" do
    visit issue_groups_url
    click_on "Edit", match: :first

    fill_in "Customtargets", with: @issue_group.customtargets
    fill_in "Description", with: @issue_group.description
    fill_in "Index", with: @issue_group.index
    fill_in "Rating", with: @issue_group.rating
    fill_in "Recommendation", with: @issue_group.recommendation
    fill_in "Severity", with: @issue_group.severity
    fill_in "Title", with: @issue_group.title
    fill_in "Type", with: @issue_group.type
    click_on "Update Issue group"

    assert_text "Issue group was successfully updated"
    click_on "Back"
  end

  it "destroying a Issue group" do
    visit issue_groups_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Issue group was successfully destroyed"
  end
end
