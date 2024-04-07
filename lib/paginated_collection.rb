# frozen_string_literal: true

PaginatedCollection = ::Struct.new(
  :collection, :current_page, :prev_page, :next_page, :total_pages, :total_count, :limit_value
) do
  include Enumerable

  delegate :length, to: :collection

  def each(&block)
    collection.each(&block)
  end
end
