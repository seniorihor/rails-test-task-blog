require 'rails_helper'

RSpec.describe 'Api::Posts', type: :request do
  describe 'GET /api/posts' do
    it 'returns all posts' do
      user1 = create(:user, username: 'user1')
      user2 = create(:user, username: 'user2')
      post1 = create(:post, title: 'First Post', content: 'Content of first post', created_by: user1)
      post2 = create(:post, title: 'Second Post', content: 'Content of second post', created_by: user2)

      get '/api/posts'

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.length).to be >= 2
      expect(json_response.map { |p| p['id'] }).to include(user1.id, user2.id)
    end

    it 'returns an empty array when there are no posts' do
      get '/api/posts'

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response).to eq([])
    end

    context 'with query parameter' do
      it 'filters posts by title' do
        user = create(:user)
        matching_post = create(:post, title: 'Ruby on Rails', content: 'Some content here', created_by: user)
        non_matching_post = create(:post, title: 'JavaScript', content: 'Other content', created_by: user)

        get '/api/posts', params: { query: 'Ruby' }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(1)
        expect(json_response.first['title']).to eq('Ruby on Rails')
      end

      it 'filters posts by content' do
        user = create(:user)
        matching_post = create(:post, title: 'Title One', content: 'Ruby programming language', created_by: user)
        non_matching_post = create(:post, title: 'Title Two', content: 'Python programming', created_by: user)

        get '/api/posts', params: { query: 'Ruby' }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(1)
        expect(json_response.first['content']).to eq('Ruby programming language')
      end

      it 'filters posts by title or content (case insensitive)' do
        user = create(:user)
        post1 = create(:post, title: 'RUBY Post', content: 'Content one', created_by: user)
        post2 = create(:post, title: 'Title two', content: 'ruby content', created_by: user)
        post3 = create(:post, title: 'Python', content: 'Python content', created_by: user)

        get '/api/posts', params: { query: 'ruby' }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(2)
      end

      it 'returns empty array when no posts match query' do
        user = create(:user)
        create(:post, title: 'Title', content: 'Content', created_by: user)

        get '/api/posts', params: { query: 'NonExistent' }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to eq([])
      end
    end
  end

  describe 'GET /api/posts/:id' do
    it 'returns a specific post' do
      user = create(:user, username: 'testuser')
      post = create(:post, title: 'Test Post', content: 'Test content here', created_by: user)

      get "/api/posts/#{post.id}"

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response).to include(
        'id' => user.id,
        'title' => 'Test Post',
        'content' => 'Test content here',
        'author' => {
          'id' => user.id,
          'name' => 'testuser'
        }
      )
    end

    it 'returns 404 when post does not exist' do
      get '/api/posts/999'

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/posts' do
    let(:user) { create(:user) }

    context 'with valid parameters' do
      it 'creates a post' do
        post_params = {
          post: {
            title: 'New Post Title',
            content: 'This is the content of the new post',
            created_by_id: user.id
          }
        }

        expect {
          post '/api/posts', params: post_params
        }.to change(Post, :count).by(1)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response).to include(
          'id' => user.id,
          'title' => 'New Post Title',
          'content' => 'This is the content of the new post',
          'author' => {
            'id' => user.id,
            'name' => user.username
          }
        )

        created_post = Post.last
        expect(created_post).to have_attributes(
          title: 'New Post Title',
          content: 'This is the content of the new post',
          created_by_id: user.id
        )
      end

      it 'creates a post with custom field values' do
        text_field = create(:custom_field_text, name: 'Description')
        number_field = create(:custom_field_number, name: 'Rating')

        post_params = {
          post: {
            title: 'Post with Custom Fields',
            content: 'Content for post with custom fields',
            created_by_id: user.id,
            custom_field_values_attributes: [
              { custom_field_id: text_field.id, value: 'Some description' },
              { custom_field_id: number_field.id, value: 5 }
            ]
          }
        }

        expect {
          post '/api/posts', params: post_params
        }.to change(Post, :count).by(1)
          .and change(CustomFieldValue, :count).by(2)

        expect(response).to have_http_status(:created)
        created_post = Post.last
        expect(created_post.custom_field_values.count).to eq(2)
      end
    end

    context 'with invalid parameters' do
      it 'returns errors when title is missing' do
        post_params = {
          post: {
            content: 'Content without title',
            created_by_id: user.id
          }
        }

        expect {
          post '/api/posts', params: post_params
        }.not_to change(Post, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Title can't be blank")
      end

      it 'returns errors when content is missing' do
        post_params = {
          post: {
            title: 'Title without content',
            created_by_id: user.id
          }
        }

        expect {
          post '/api/posts', params: post_params
        }.not_to change(Post, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Content can't be blank")
      end

      it 'returns errors when title is too short' do
        post_params = {
          post: {
            title: 'Hi',
            content: 'Content that is long enough',
            created_by_id: user.id
          }
        }

        expect {
          post '/api/posts', params: post_params
        }.not_to change(Post, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include('Title is too short (minimum is 5 characters)')
      end

      it 'returns errors when content is too short' do
        post_params = {
          post: {
            title: 'Valid Title Here',
            content: 'Hi',
            created_by_id: user.id
          }
        }

        expect {
          post '/api/posts', params: post_params
        }.not_to change(Post, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include('Content is too short (minimum is 5 characters)')
      end

      it 'returns errors when created_by_id is missing' do
        post_params = {
          post: {
            title: 'Valid Title Here',
            content: 'Valid content here'
          }
        }

        expect {
          post '/api/posts', params: post_params
        }.not_to change(Post, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Created by can't be blank")
      end
    end
  end

  describe 'PATCH /api/posts/:id' do
    let(:user) { create(:user) }
    let(:post) { create(:post, title: 'Original Title', content: 'Original content here', created_by: user) }

    context 'with valid parameters' do
      it 'updates the post' do
        update_params = {
          post: {
            title: 'Updated Title',
            content: 'Updated content here'
          }
        }

        patch "/api/posts/#{post.id}", params: update_params

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to include(
          'title' => 'Updated Title',
          'content' => 'Updated content here'
        )

        post.reload
        expect(post).to have_attributes(
          title: 'Updated Title',
          content: 'Updated content here'
        )
      end

      it 'updates custom field values' do
        text_field = create(:custom_field_text, name: 'Description')
        custom_field_value = create(:custom_field_value_text, post: post, custom_field: text_field, value: 'Old value')

        update_params = {
          post: {
            custom_field_values_attributes: [
              { id: custom_field_value.id, custom_field_id: text_field.id, value: 'New value' }
            ]
          }
        }

        patch "/api/posts/#{post.id}", params: update_params

        expect(response).to have_http_status(:ok)
        custom_field_value.reload
        expect(custom_field_value).to have_attributes(value: 'New value')
      end

      it 'creates new custom field values on update' do
        text_field = create(:custom_field_text, name: 'Description')

        update_params = {
          post: {
            custom_field_values_attributes: [
              { custom_field_id: text_field.id, value: 'New custom field value' }
            ]
          }
        }

        expect {
          patch "/api/posts/#{post.id}", params: update_params
        }.to change(CustomFieldValue, :count).by(1)

        expect(response).to have_http_status(:ok)
        expect(post.custom_field_values.count).to eq(1)
      end

      it 'deletes custom field values with _destroy flag' do
        text_field = create(:custom_field_text, name: 'Description')
        custom_field_value = create(:custom_field_value_text, post: post, custom_field: text_field)

        update_params = {
          post: {
            custom_field_values_attributes: [
              { id: custom_field_value.id, _destroy: '1' }
            ]
          }
        }

        expect {
          patch "/api/posts/#{post.id}", params: update_params
        }.to change(CustomFieldValue, :count).by(-1)

        expect(response).to have_http_status(:ok)
        expect(post.custom_field_values.count).to eq(0)
      end
    end

    context 'with invalid parameters' do
      it 'returns errors when title is set to blank' do
        update_params = {
          post: {
            title: ''
          }
        }

        patch "/api/posts/#{post.id}", params: update_params

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Title can't be blank")

        post.reload
        expect(post).to have_attributes(title: 'Original Title')
      end

      it 'returns errors when title is too short' do
        update_params = {
          post: {
            title: 'Hi'
          }
        }

        patch "/api/posts/#{post.id}", params: update_params

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include('Title is too short (minimum is 5 characters)')
      end

      it 'returns errors when content is too short' do
        update_params = {
          post: {
            content: 'Hi'
          }
        }

        patch "/api/posts/#{post.id}", params: update_params

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include('Content is too short (minimum is 5 characters)')
      end
    end

    it 'returns 404 when post does not exist' do
      update_params = {
        post: {
          title: 'Updated Title'
        }
      }

      patch '/api/posts/999', params: update_params

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PUT /api/posts/:id' do
    let(:user) { create(:user) }
    let(:post) { create(:post, title: 'Original Title', content: 'Original content', created_by: user) }

    it 'updates the post' do
      update_params = {
        post: {
          title: 'Updated Title',
          content: 'Updated content'
        }
      }

      put "/api/posts/#{post.id}", params: update_params

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response).to include(
        'title' => 'Updated Title',
        'content' => 'Updated content'
      )
    end
  end

  describe 'DELETE /api/posts/:id' do
    it 'deletes the post' do
      post = create(:post)

      expect {
        delete "/api/posts/#{post.id}"
      }.to change(Post, :count).by(-1)

      expect(response).to have_http_status(:no_content)
      expect(Post.find_by(id: post.id)).to be_nil
    end

    it 'returns 404 when post does not exist' do
      delete '/api/posts/999'

      expect(response).to have_http_status(:not_found)
    end

    it 'deletes associated custom field values when post is deleted' do
      post = create(:post)
      custom_field = create(:custom_field_text)
      custom_field_value = create(:custom_field_value_text, post: post, custom_field: custom_field)

      expect {
        delete "/api/posts/#{post.id}"
      }.to change(Post, :count).by(-1)
        .and change(CustomFieldValue, :count).by(-1)

      expect(response).to have_http_status(:no_content)
      expect(CustomFieldValue.find_by(id: custom_field_value.id)).to be_nil
    end
  end
end
