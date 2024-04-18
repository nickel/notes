class AddSearchableColumnToNotes < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      ALTER TABLE notes
      ADD COLUMN searchable tsvector GENERATED ALWAYS AS (
        setweight(to_tsvector('english', coalesce(title, '')), 'A') ||
        setweight(to_tsvector('english', coalesce(content,'')), 'B') ||
        setweight(array_to_tsvector(tags), 'C')
      ) STORED;
    SQL
  end

  def down
    remove_column :notes, :searchable
  end
end
