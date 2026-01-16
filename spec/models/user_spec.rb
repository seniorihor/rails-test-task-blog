require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:posts).with_foreign_key('created_by_id').dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:email) }
  end

  describe 'callbacks' do
    describe 'after_create' do
      let(:user) { build(:user) }

      context 'when user is created' do
        it 'sends welcome email' do
          expect(UserMailer).to receive(:welcome_email).with(instance_of(User)).and_return(double(deliver_now: true))
          user.save!
        end

        it 'creates a welcome post' do
          user.save!
          expect(user.posts.count).to eq(1)
          expect(user.posts.first.title).to eq('Welcome to my blog')
          expect(user.posts.first.content).to eq('This is my first post. Stay tuned for more updates!')
        end
      end
    end
  end

  describe '#send_welcome_email' do
    let(:user) { create(:user) }

    it 'delivers welcome email via UserMailer' do
      mailer_double = double('mailer')
      expect(UserMailer).to receive(:welcome_email).with(user).and_return(mailer_double)
      expect(mailer_double).to receive(:deliver_now)
      user.send_welcome_email
    end
  end

  describe '#create_welcome_post' do
    let(:user) { create(:user) }

    it 'creates a welcome post with correct attributes' do
      user.create_welcome_post
      post = user.posts.last
      expect(post.title).to eq('Welcome to my blog')
      expect(post.content).to eq('This is my first post. Stay tuned for more updates!')
    end
  end
end
