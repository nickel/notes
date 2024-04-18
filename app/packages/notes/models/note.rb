# frozen_string_literal: true

class Note < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search,
                  against: { title: "A", content: "B", tags: "C" },
                  using: {
                    tsearch: {
                      dictionary: "simple", tsvector_column: "searchable"
                    }
                  }

  def intro
    return "" unless content.present?

    content
      .split("\n")
      .first
  end

  def to_struct
    CustomStruct.new(
      attributes
        .merge(intro:)
    )
  end

  def to_param
    [id, title.parameterize].join("-")
  end
end
