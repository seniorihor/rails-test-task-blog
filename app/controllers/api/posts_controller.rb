module Api
  class PostsController < ApplicationController
    before_action :set_post, only: [ :show, :update, :destroy ]

    # GET /api/posts
    def index
      @posts = Post.all

      if params[:query].present?
        @posts = @posts.where("title ILIKE ? OR content ILIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
      end

      render json: Api::PostPresenter.new(@posts).as_json
    end

    # GET /api/posts/1
    def show
      render json: Api::PostPresenter.new(@post).as_json
    end

    # POST /api/posts
    def create
      @post = Post.new(post_params)

      if @post.save
        render json: Api::PostPresenter.new(@post).as_json, status: :created
      else
        render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/posts/1
    def update
      if @post.update(post_params)
        render json: Api::PostPresenter.new(@post).as_json
      else
        render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /api/posts/1
    def destroy
      @post.destroy
      head :no_content
    end

    private

      def set_post
        @post = Post.find(params[:id])
      end

      def post_params
        params.require(:post).permit(
          :title, :content, :created_by_id,
          custom_field_values_attributes: [ :id, :custom_field_id, :value, :_destroy ]
        ).tap do |permitted|
          if permitted[:custom_field_values_attributes].present?
            permitted[:custom_field_values_attributes].each do |attrs|
              next if attrs[:custom_field_id].blank?
              custom_field = CustomField.find(attrs[:custom_field_id])
              attrs[:type] = custom_field.type.gsub("CustomField", "CustomFieldValue")
            end
          end
        end
      end
  end
end
