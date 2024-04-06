# frozen_string_literal: true

module WithResponse
  extend ActiveSupport::Concern

  def save_with_response(**args)
    assign_attributes(args)

    if save
      Response.success(self)
    else
      Response.failure(
        Errors::Error.build(
          code: :cant_be_saved,
          message: errors.full_messages.to_sentence,
          data: errors.details
        )
      )
    end
  end

  def update_with_response(args)
    if errors.details.empty? && update(args)
      Response.success(self)
    else
      Response.failure(
        Errors::Error.build(
          code: :cant_be_updated,
          message: errors.full_messages.to_sentence,
          data: errors.details
        )
      )
    end
  end

  def destroy_with_response
    if destroy
      Response.success(self)
    else
      Response.failure(
        Errors::Error.build(
          code: :cant_be_destroyed,
          message: errors.full_messages.to_sentence,
          data: errors.details
        )
      )
    end
  end
end
