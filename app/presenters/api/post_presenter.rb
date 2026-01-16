module Api
  class PostPresenter
    def initialize(post)
      @post = post
    end

    def as_json
      if @post.is_a?(ActiveRecord::Relation)
        @post.map { |post| serialize_post(post) }
      else
        serialize_post(@post)
      end
    end

    private

      def serialize_post(post)
        {
          id: post.created_by.id,
          author: {
            id: post.created_by.id,
            name: post.created_by.username
          },
          title: post.title,
          content: post.content
        }
      end
  end
end
