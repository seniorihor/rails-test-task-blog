require 'rails_helper'

RSpec.describe 'Api::CustomFields', type: :request do
  describe 'GET /api/custom_fields' do
    it 'returns all custom fields' do
      custom_field1 = create(:custom_field_text, name: 'Field 1')
      custom_field2 = create(:custom_field_number, name: 'Field 2')

      get '/api/custom_fields'

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(2)
      expect(json_response.map { |cf| cf['id'] }).to contain_exactly(custom_field1.id, custom_field2.id)
    end

    it 'returns an empty array when there are no custom fields' do
      get '/api/custom_fields'

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response).to eq([])
    end
  end

  describe 'GET /api/custom_fields/:id' do
    it 'returns a specific custom field' do
      custom_field = create(:custom_field_text, name: 'Test Field', required: true)

      get "/api/custom_fields/#{custom_field.id}"

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response).to include(
        'id' => custom_field.id,
        'name' => 'Test Field',
        'type' => 'CustomField::Text',
        'required' => true
      )
    end

    it 'returns 404 when custom field does not exist' do
      get '/api/custom_fields/999'

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/custom_fields' do
    context 'with valid parameters' do
      it 'creates a text custom field' do
        custom_field_params = {
          custom_field: {
            name: 'New Text Field',
            type: 'CustomField::Text',
            required: false
          }
        }

        expect {
          post '/api/custom_fields', params: custom_field_params
        }.to change(CustomField, :count).by(1)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response).to include(
          'name' => 'New Text Field',
          'type' => 'CustomField::Text',
          'required' => false
        )
      end

      it 'creates a number custom field' do
        custom_field_params = {
          custom_field: {
            name: 'New Number Field',
            type: 'CustomField::Number',
            required: true
          }
        }

        post '/api/custom_fields', params: custom_field_params

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response).to include(
          'name' => 'New Number Field',
          'type' => 'CustomField::Number',
          'required' => true
        )
      end

      it 'creates a select custom field with options' do
        custom_field_params = {
          custom_field: {
            name: 'New Select Field',
            type: 'CustomField::Select',
            options: [ 'Option 1', 'Option 2', 'Option 3' ],
            required: false
          }
        }

        post '/api/custom_fields', params: custom_field_params

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response).to include(
          'name' => 'New Select Field',
          'type' => 'CustomField::Select',
          'options' => [ 'Option 1', 'Option 2', 'Option 3' ]
        )
      end

      it 'creates a multiselect custom field with options' do
        custom_field_params = {
          custom_field: {
            name: 'New Multiselect Field',
            type: 'CustomField::Multiselect',
            options: [ 'Choice A', 'Choice B' ],
            required: true
          }
        }

        post '/api/custom_fields', params: custom_field_params

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response).to include(
          'name' => 'New Multiselect Field',
          'type' => 'CustomField::Multiselect',
          'options' => [ 'Choice A', 'Choice B' ]
        )
      end
    end

    context 'with invalid parameters' do
      it 'returns errors when name is missing' do
        custom_field_params = {
          custom_field: {
            type: 'CustomField::Text',
            required: false
          }
        }

        expect {
          post '/api/custom_fields', params: custom_field_params
        }.not_to change(CustomField, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Name can't be blank")
      end

      it 'returns errors when type is missing' do
        custom_field_params = {
          custom_field: {
            name: 'Field Without Type',
            required: false
          }
        }

        expect {
          post '/api/custom_fields', params: custom_field_params
        }.not_to change(CustomField, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Type can't be blank")
      end

      it 'returns errors when both name and type are missing' do
        custom_field_params = {
          custom_field: {
            required: false
          }
        }

        expect {
          post '/api/custom_fields', params: custom_field_params
        }.not_to change(CustomField, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Name can't be blank", "Type can't be blank")
      end
    end
  end

  describe 'PATCH /api/custom_fields/:id' do
    let(:custom_field) { create(:custom_field_text, name: 'Original Name', required: false) }

    context 'with valid parameters' do
      it 'updates the custom field' do
        update_params = {
          custom_field: {
            name: 'Updated Name',
            required: true
          }
        }

        patch "/api/custom_fields/#{custom_field.id}", params: update_params

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to include(
          'name' => 'Updated Name',
          'required' => true,
          'type' => 'CustomField::Text'
        )

        custom_field.reload
        expect(custom_field).to have_attributes(
          name: 'Updated Name',
          required: true
        )
      end

      it 'updates options for select field' do
        select_field = create(:custom_field_select, name: 'Select Field', options: [ 'Old Option 1', 'Old Option 2' ])
        update_params = {
          custom_field: {
            options: [ 'New Option 1', 'New Option 2' ]
          }
        }

        patch "/api/custom_fields/#{select_field.id}", params: update_params

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to include('options' => [ 'New Option 1', 'New Option 2' ])

        select_field.reload
        expect(select_field).to have_attributes(options: [ 'New Option 1', 'New Option 2' ])
      end

      it 'updates type' do
        update_params = {
          custom_field: {
            type: 'CustomField::Number'
          }
        }

        patch "/api/custom_fields/#{custom_field.id}", params: update_params

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to include('type' => 'CustomField::Number')

        # Reload as base class since type changed
        updated_field = CustomField.find(custom_field.id)
        expect(updated_field).to have_attributes(type: 'CustomField::Number')
      end
    end

    context 'with invalid parameters' do
      it 'returns errors when name is set to blank' do
        update_params = {
          custom_field: {
            name: ''
          }
        }

        patch "/api/custom_fields/#{custom_field.id}", params: update_params

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Name can't be blank")

        custom_field.reload
        expect(custom_field).to have_attributes(name: 'Original Name')
      end

      it 'returns errors when type is set to blank' do
        update_params = {
          custom_field: {
            type: ''
          }
        }

        patch "/api/custom_fields/#{custom_field.id}", params: update_params

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Type can't be blank")
      end
    end

    it 'returns 404 when custom field does not exist' do
      update_params = {
        custom_field: {
          name: 'Updated Name'
        }
      }

      patch '/api/custom_fields/999', params: update_params

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PUT /api/custom_fields/:id' do
    let(:custom_field) { create(:custom_field_text, name: 'Original Name') }

    it 'updates the custom field' do
      update_params = {
        custom_field: {
          name: 'Updated Name',
          required: true
        }
      }

      put "/api/custom_fields/#{custom_field.id}", params: update_params

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response).to include(
        'name' => 'Updated Name',
        'required' => true
      )
    end
  end

  describe 'DELETE /api/custom_fields/:id' do
    it 'deletes the custom field' do
      custom_field = create(:custom_field_text)

      expect {
        delete "/api/custom_fields/#{custom_field.id}"
      }.to change(CustomField, :count).by(-1)

      expect(response).to have_http_status(:no_content)
      expect(CustomField.find_by(id: custom_field.id)).to be_nil
    end

    it 'returns 404 when custom field does not exist' do
      delete '/api/custom_fields/999'

      expect(response).to have_http_status(:not_found)
    end

    it 'deletes associated custom field values when custom field is deleted' do
      custom_field = create(:custom_field_text)
      post = create(:post)
      custom_field_value = create(:custom_field_value_text, custom_field: custom_field, post: post)

      expect {
        delete "/api/custom_fields/#{custom_field.id}"
      }.to change(CustomFieldValue, :count).by(-1)

      expect(response).to have_http_status(:no_content)
      expect(CustomFieldValue.find_by(id: custom_field_value.id)).to be_nil
    end
  end
end
