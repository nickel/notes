# frozen_string_literal: true

module Factory
  module_function

  def generate_note(**input)
    Note::Create
      .call(**{ title: "My wonderful note",
                content: "Lorem ipsum dolor sit amet",
                tags: "note" }.merge(input))
      .value!
  end
end
