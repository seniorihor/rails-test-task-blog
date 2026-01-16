class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.belongs_to :created_by, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
