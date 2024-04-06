# frozen_string_literal: true

class Note < ApplicationRecord
  def to_struct
    CustomStruct.new(attributes)
  end

  def to_param
    [id, title.parameterize].join("-")
  end
end
