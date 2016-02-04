require 'rails_helper'

describe CommentsController do
  let(:json_response) { JSON.parse(response.body) }
  let(:user) { create(:user) }
  let(:article) { create(:article, user: user) }

  describe '#index' do
    let(:comment_keys) do
      %w(id content article_id created_at updated_at user)
    end

    before do
      3.times { create(:comment, user: user, article: article) }
      get :index, article_id: article.id
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(json_response.size).to eq(3) }
    it { expect(json_response.first.keys).to eq(comment_keys) }
    it { expect(json_response.first['user'].keys).to eq(%w(id username)) }
  end

  describe '#create' do
    before do
      sign_in user
      post :create, article_id: article.id,
                    comment: { content: 'Comment content' }
    end

    it { expect(response).to have_http_status(:created) }
    it { expect(json_response['content']).to eq('Comment content') }
  end

  describe '#update' do
    let(:comment) do
      create(:comment, content: 'Test content', article: article, user: user)
    end

    before do
      sign_in user
      put :update, id: comment.id, article_id: article.id,
                   comment: { content: 'Edited content' }
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(json_response['content']).to eq('Edited content') }
  end

  describe '#destroy' do
    let(:comment) { create(:comment, user: user, article: article) }

    before do
      sign_in user
      delete :destroy, article_id: article.id, id: comment.id
    end

    it { expect(response).to have_http_status(:ok) }
  end
end
