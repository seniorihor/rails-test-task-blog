module Api
  class CustomFieldPresenter
    def initialize(custom_field)
      @custom_field = custom_field
    end

    def as_json
      if @custom_field.is_a?(ActiveRecord::Relation)
        @custom_field.map { |field| serialize_custom_field(field) }
      else
        serialize_custom_field(@custom_field)
      end
    end

    private

    def serialize_custom_field(custom_field)
      {
        id: custom_field.id,
        name: custom_field.name,
        type: custom_field.type,
        options: custom_field.options,
        required: custom_field.required,
        created_at: custom_field.created_at,
        updated_at: custom_field.updated_at
      }
    end
  end
end
