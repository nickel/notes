# frozen_string_literal: true

class Note::Find < CommandHandler::Command
  class Form
    include CommandHandler::Form

    attribute :note_id, :integer

    validates :note_id, presence: true
  end

  delegate :note_id, to: :form

  def execute
    if (note = Note.find_by(id: note_id))
      Response.success(note.to_struct)
    else
      Response.failure(
        CommandHandler::Errors::RecordNotFoundError
          .build(form:)
      )
    end
  end
end
