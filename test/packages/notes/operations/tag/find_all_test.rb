# frozen_string_literal: true

require "test_helper"

class Tag::FindAllTest < ActiveSupport::TestCase
  test "tags are grouped" do
    3.times { Factory.generate_note(private: false, tags: "foo, bar") }

    response = Tag::FindAll.call

    assert response.success?
    assert_equal 2, response.value.length

    response.value.to_h.each_value do |count|
      assert_equal 3, count
    end
  end
end
