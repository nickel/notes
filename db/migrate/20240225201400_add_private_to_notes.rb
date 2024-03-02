class AddPrivateToNotes < ActiveRecord::Migration[7.1]
  def change
    add_column :notes, :private, :boolean, default: false, null: false
  end
end
