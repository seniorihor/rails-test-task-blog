class CreateCustomFields < ActiveRecord::Migration[8.0]
  def change
    create_table :custom_fields do |t|
      t.string :name, null: false
      t.string :type, null: false
      t.json :options
      t.boolean :required, default: false

      t.timestamps
    end
  end
end
