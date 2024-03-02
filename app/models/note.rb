class Note < ApplicationRecord
  def to_param
    [id, title.parameterize].join("-")
  end
end
