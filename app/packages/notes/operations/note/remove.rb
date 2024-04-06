# frozen_string_literal: true

class Note::Remove < CommandHandler::Command
  class Form
    include CommandHandler::Form

    attribute :note_id, :integer

    validates :note_id, presence: true
  end

  delegate :note_id, to: :form

  def execute
    Note::Find
      .call(note_id:)
      .and_then do |note|
        Response.success(
          Note
            .destroy(note.id)
            .to_struct
        )
      end
  end
end
