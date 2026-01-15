class AddTypeToCustomFieldValues < ActiveRecord::Migration[8.0]
  def change
    add_column :custom_field_values, :type, :string
  end
end
