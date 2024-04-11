# frozen_string_literal: true

class Note < ApplicationRecord
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
