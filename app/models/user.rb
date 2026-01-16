class User < ApplicationRecord
  has_many :posts, foreign_key: "created_by_id", dependent: :destroy, inverse_of: :created_by

  validates :username, :first_name, presence: true
  validates :email, presence: true

  after_create :send_welcome_email
  after_create :create_welcome_post

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
  end

  def create_welcome_post
    self.posts.create!(
      title: "Welcome to my blog",
      content: "This is my first post. Stay tuned for more updates!"
    )
  end
end
