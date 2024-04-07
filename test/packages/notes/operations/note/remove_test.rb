# frozen_string_literal: true

require "test_helper"

class Note::RemoveTest < ActiveSupport::TestCase
  test "note is remove" do
    note = Factory.generate_note

    response = Note::Remove.call(note_id: note.id)

    assert response.success?
    assert Note::Find.call(note_id: note.id).failure?
  end

  test "when inputs are not valid" do
    response = Note::Remove.call

    assert response.failure?
    assert_equal CommandHandler::Errors::InvalidInputError, response.value.class
  end
end
