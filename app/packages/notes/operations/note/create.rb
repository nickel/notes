# frozen_string_literal: true

class Note::Create < CommandHandler::Command
  class Form
    include CommandHandler::Form

    attribute :title, :string
    attribute :content, :string
    attribute :tags, default: []
    attribute :private, :boolean, default: true

    validates :title, presence: true

    def tags=(value)
      new_value = if value.is_a?(String)
                    (value || "").split(",").map(&:strip)
                  else
                    value
                  end

      super(new_value)
    end
  end

  delegate(*Form.new.attributes.keys, to: :form)

  def execute
    Note
      .new(title:, content:, tags:, private:)
      .save_with_response
      .and_then do |note|
        Response.success(note.to_struct)
      end
  end
end
