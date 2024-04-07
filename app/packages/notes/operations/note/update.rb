# frozen_string_literal: true

class Note::Update < CommandHandler::Command
  class Form
    include CommandHandler::Form

    attribute :note_id, :string
    attribute :title, :string
    attribute :content, :string
    attribute :tags, default: []
    attribute :private, :boolean, default: true

    validates :note_id, :title, presence: true

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
    Note::Find
      .call(note_id:)
      .and_then do
        Note
          .find_by(id: note_id)
          .update_with_response(title:, content:, tags:, private:)
          .and_then do |note|
            Response.success(note.to_struct)
          end
      end
  end
end
