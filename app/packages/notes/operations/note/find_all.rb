# frozen_string_literal: true

class Note::FindAll < CommandHandler::Command
  BY_VISIBILITY_FILTERS = %w(public private).freeze

  class Form
    include CommandHandler::Form

    attribute :by_tag
    attribute :by_visibility, :string, default: "public"

    validates :by_visibility, inclusion: { in: BY_VISIBILITY_FILTERS }
  end

  delegate(*Form.new.attributes.keys, to: :form)

  def call
    Response.success(find_all)
  end

  private

  def find_all
    notes = by_visibility == "private" ? Note.where(private: false) : Note.all
    notes = notes.where("? = ANY(tags)", by_tag) if by_tag.present?
    notes
  end
end
