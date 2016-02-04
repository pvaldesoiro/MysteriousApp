class Comment < ActiveRecord::Base
  belongs_to :article
  belongs_to :user

  def self.json_format
    { except: :user_id, include: { user: { only: [:id, :username] } } }
  end

  def to_json_format
    to_json(Comment.json_format)
  end
end
