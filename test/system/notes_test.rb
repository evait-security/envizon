require "application_system_test_case"

describe "Notes", :system do
  let(:note) { notes(:one) }

  it "visiting the index" do
    visit notes_url
    assert_selector "h1", text: "Notes"
  end

  it "creating a Note" do
    visit notes_url
    click_on "New Note"

    fill_in "Content", with: @note.content
    fill_in "Noteable", with: @note.noteable_id
    fill_in "Noteable type", with: @note.noteable_type
    click_on "Create Note"

    assert_text "Note was successfully created"
    click_on "Back"
  end

  it "updating a Note" do
    visit notes_url
    click_on "Edit", match: :first

    fill_in "Content", with: @note.content
    fill_in "Noteable", with: @note.noteable_id
    fill_in "Noteable type", with: @note.noteable_type
    click_on "Update Note"

    assert_text "Note was successfully updated"
    click_on "Back"
  end

  it "destroying a Note" do
    visit notes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Note was successfully destroyed"
  end
end
