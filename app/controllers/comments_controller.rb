class CommentsController < ApiController
  def index
    render json: Article.find(params[:article_id]).comments.all
  end

  def create
    if user_signed_in?
      comment = Article.find(params[:article_id])
                       .comments.new(comment_params.merge(user: current_user))

      if comment.save
        render json: comment, status: :created
      else
        render unprocessable_entity_error('comment', 'create')
      end
    else
      render insufficient_permissions_error
    end
  end

  def update
    comment = Comment.find(params[:id])

    owner?(comment) do
      if comment.update(comment_params)
        render json: comment, status: :ok
      else
        render unprocessable_entity_error('comment', 'update')
      end
    end
  end

  def destroy
    comment = Comment.find(params[:id])

    owner_or_admin?(comment) do
      if comment.destroy
        render json: comment, status: :ok
      else
        render unprocessable_entity_error('comment', 'destroy')
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
