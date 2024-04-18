class AddIndexToSearchableNotes < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :notes, :searchable, using: :gin, algorithm: :concurrently
  end
end
