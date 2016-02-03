require 'rails_helper'

describe ArticlesController do
  let(:json_response) { JSON.parse(response.body) }
  let(:user) { create(:user) }

  describe '#index' do
    let(:article_keys) do
      %w(id title content user_id created_at updated_at comments)
    end

    before do
      2.times { create(:article, user: user) }
      create(:comment, user: user, article: create(:article, user: user))
      get :index
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(json_response.size).to eq(3) }
    it { expect(json_response.first.keys).to eq(article_keys) }
  end

  describe '#create' do
    context 'without user signed in' do
      before do
        post :create, article: { title: 'Article title',
                                 content: 'Article content' }
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'with user signed in' do
      before do
        sign_in user
        post :create, article: { title: 'Article title',
                                 content: 'Article content' }
      end

      it { expect(response).to have_http_status(:created) }
      it { expect(json_response['title']).to eq('Article title') }
      it { expect(json_response['content']).to eq('Article content') }
    end
  end

  describe '#update' do
    let(:article) do
      create(:article, title: 'Test title', content: 'Test content',
                       user: user)
    end

    before do
      sign_in user
      put :update, id: article.id,
                   article: { title: 'Edited title',
                              content: 'Edited content' }
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(json_response['title']).to eq('Edited title') }
    it { expect(json_response['content']).to eq('Edited content') }
  end

  describe '#destroy' do
    let(:article) { create(:article, user: user) }
    let(:other_user) { create(:user) }
    let(:admin_user) { create(:user, admin: true) }

    describe 'not the owner user' do
      before do
        sign_in other_user
        delete :destroy, id: article.id
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end

    describe 'the owner user' do
      before do
        sign_in user
        delete :destroy, id: article.id
      end

      it { expect(response).to have_http_status(:ok) }
    end

    describe 'the admin user' do
      before do
        sign_in user
        delete :destroy, id: article.id
      end

      it { expect(response).to have_http_status(:ok) }
    end
  end
end
