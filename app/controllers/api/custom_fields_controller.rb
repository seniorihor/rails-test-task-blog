module Api
  class CustomFieldsController < ApplicationController
    before_action :set_custom_field, only: [ :show, :update, :destroy ]

    def index
      @custom_fields = CustomField.all
      render json: Api::CustomFieldPresenter.new(@custom_fields).as_json
    end

    def show
      render json: Api::CustomFieldPresenter.new(@custom_field).as_json
    end

    def create
      @custom_field = CustomField.new(custom_field_params)

      if @custom_field.save
        render json: Api::CustomFieldPresenter.new(@custom_field).as_json, status: :created
      else
        render json: { errors: @custom_field.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @custom_field.update(custom_field_params)
        render json: Api::CustomFieldPresenter.new(@custom_field).as_json
      else
        render json: { errors: @custom_field.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @custom_field.destroy
      head :no_content
    end

    private

    def set_custom_field
      @custom_field = CustomField.find(params[:id])
    end

    def custom_field_params
      params.require(:custom_field).permit(:name, :type, :options, :required, options: [])
    end
  end
end
