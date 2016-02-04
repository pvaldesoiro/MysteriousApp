class Article < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :delete_all

  def self.json_format
    {
      except: :user_id,
      include: {
        user: {
          only: [:id, :username]
        },
        comments: {
          except: :user_id,
          include: { user: { only: [:id, :username] } }
        }
      }
    }
  end

  def to_json_format
    to_json(Article.json_format)
  end
end
