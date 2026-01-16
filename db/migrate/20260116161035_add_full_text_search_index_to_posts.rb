class AddFullTextSearchIndexToPosts < ActiveRecord::Migration[8.0]
  def change
    # Enable trigram extension for efficient ILIKE searches
    enable_extension "pg_trgm"

    # Add GiST indexes on title and content for faster ILIKE queries
    add_index :posts, :title, using: :gist, opclass: :gist_trgm_ops
    add_index :posts, :content, using: :gist, opclass: :gist_trgm_ops
  end
end
