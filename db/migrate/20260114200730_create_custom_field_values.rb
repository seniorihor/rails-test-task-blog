class CreateCustomFieldValues < ActiveRecord::Migration[8.0]
  def change
    create_table :custom_field_values do |t|
      t.belongs_to :post, null: false, index: true, foreign_key: true
      t.belongs_to :custom_field, null: false, index: true, foreign_key: true

      t.string :type, null: false
      t.json :value

      t.timestamps
    end
  end
end
