# frozen_string_literal: true

require "test_helper"

class Note::CreateTest < ActiveSupport::TestCase
  test "note creation with the proper values" do
    response = Note::Create
      .call(
        title: "My wonderful note",
        content: "Lorem ipsum dolor sit amet",
        tags: "note, first"
      )

    assert response.success?

    note = response.value

    assert_equal "My wonderful note", note.title
    assert_equal "Lorem ipsum dolor sit amet", note.content
    assert_equal %w(note first).sort, note.tags.sort
    assert note.private
  end

  test "public note creation" do
    response = Note::Create
      .call(
        title: "My wonderful note",
        private: false
      )

    assert response.success?

    note = response.value

    refute note.private
  end

  test "note creation requires a title" do
    response = Note::Create.call

    assert response.failure?
    assert response.value.data.errors.key?(:title)
  end
end
