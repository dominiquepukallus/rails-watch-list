class AddUniqueIndexToBookmarks < ActiveRecord::Migration[8.1]
  def change
    add_index :bookmarks, [:movie_id, :list_id], unique: true
  end
end
