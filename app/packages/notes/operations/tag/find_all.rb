# frozen_string_literal: true

class Tag::FindAll < CommandHandler::Command
  BY_VISIBILITY_FILTERS = Note::FindAll::BY_VISIBILITY_FILTERS

  class Form
    include CommandHandler::Form

    attribute :by_visibility, :string, default: "public"

    validates :by_visibility, inclusion: { in: BY_VISIBILITY_FILTERS }
  end

  delegate(*Form.new.attributes.keys, to: :form)

  def call
    Response.success(find_all)
  end

  private

  def find_all
    notes = Note.select(:tags)
    notes = by_visibility == "private" ? notes : Note.where(private: false)

    notes
      .map(&:tags)
      .flatten
      .tally
      .sort_by { |_, count| -count }
  end
end
