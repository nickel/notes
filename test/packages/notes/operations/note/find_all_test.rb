# frozen_string_literal: true

require "test_helper"

class Note::FindAllTest < ActiveSupport::TestCase
  test "public notes are found" do
    3.times { Factory.generate_note(private: false) }

    response = Note::FindAll.call

    assert response.success?
    assert_equal 3, response.value.length
  end

  test "public notes are found using queries (on title)" do
    3.times { Factory.generate_note }
    3.times { Factory.generate_note(title: "foo") }

    response = Note::FindAll.call(by_visibility: "private", by_query: "foo")

    assert response.success?
    assert_equal 3, response.value.length
  end

  test "public notes are found using queries (on content)" do
    3.times { Factory.generate_note }
    3.times { Factory.generate_note(content: "foo") }

    response = Note::FindAll.call(by_visibility: "private", by_query: "foo")

    assert response.success?
    assert_equal 3, response.value.length
  end

  test "public notes are found using queries (on tags)" do
    3.times { Factory.generate_note }
    3.times { Factory.generate_note(tags: "foo, bar") }

    response = Note::FindAll.call(by_visibility: "private", by_query: "foo")

    assert response.success?
    assert_equal 3, response.value.length
  end

  test "private notes are not found" do
    3.times { Factory.generate_note(private: true) }

    response = Note::FindAll.call

    assert response.success?
    assert_equal 0, response.value.length
  end

  test "private notes are found" do
    3.times { Factory.generate_note(private: true) }

    response = Note::FindAll.call(by_visibility: "private")

    assert response.success?
    assert_equal 3, response.value.length
  end

  test "notes are filtered by tags" do
    3.times { Factory.generate_note(private: false, tags: "foo, bar") }

    response = Note::FindAll.call(by_tag: "bar")

    assert response.success?
    assert_equal 3, response.value.length
  end
end
