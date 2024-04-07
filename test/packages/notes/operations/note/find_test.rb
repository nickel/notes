# frozen_string_literal: true

require "test_helper"

class Note::FindTest < ActiveSupport::TestCase
  test "note is found" do
    note = Factory.generate_note

    response = Note::Find.call(note_id: note.id)

    assert response.success?
    assert_equal note.id, response.value.id
  end

  test "note is not found" do
    response = Note::Find.call(note_id: -1)

    assert response.failure?
    assert_equal CommandHandler::Errors::RecordNotFoundError, response.value.class
  end

  test "when inputs are not valid" do
    response = Note::Find.call

    assert response.failure?
    assert_equal CommandHandler::Errors::InvalidInputError, response.value.class
  end
end
