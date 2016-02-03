class ArticlesController < ApiController
  def index
    render json: Article.all.to_json(include: :comments)
  end

  def create
    if user_signed_in?
      article = Article.new(article_params.merge(user: current_user))

      if article.save
        render json: article, status: :created
      else
        render json: unprocessable_entity_error('article', 'create')
      end
    else
      render insufficient_permissions_error
    end
  end

  def update
    article = Article.find(params[:id])

    owner?(article) do
      if article.update(article_params)
        render json: article, status: :ok
      else
        render unprocessable_entity_error('article', 'update')
      end
    end
  end

  def destroy
    article = Article.find(params[:id])

    owner_or_admin?(article) do
      if article.destroy
        render json: article, status: :ok
      else
        render unprocessable_entity_error('article', 'delete')
      end
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :content)
  end
end
