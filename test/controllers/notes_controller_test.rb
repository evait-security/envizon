require "test_helper"

describe NotesController do
  let(:note) { notes(:one) }

  it "should get index" do
    get notes_url
    must_respond_with :success
  end

  it "should get new" do
    get new_note_url
    must_respond_with :success
  end

  it "should create note" do
    assert_difference("Note.count") do
      post notes_url, params: { note: { content: @note.content, noteable_id: @note.noteable_id, noteable_type: @note.noteable_type } }
    end

    must_redirect_to note_url(Note.last)
  end

  it "should show note" do
    get note_url(@note)
    must_respond_with :success
  end

  it "should get edit" do
    get edit_note_url(@note)
    must_respond_with :success
  end

  it "should update note" do
    patch note_url(@note), params: { note: { content: @note.content, noteable_id: @note.noteable_id, noteable_type: @note.noteable_type } }
    must_redirect_to note_url(note)
  end

  it "should destroy note" do
    assert_difference("Note.count", -1) do
      delete note_url(@note)
    end

    must_redirect_to notes_url
  end
end
