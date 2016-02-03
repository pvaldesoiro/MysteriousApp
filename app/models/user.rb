class User < ActiveRecord::Base
  has_many :articles
  has_many :comments

  devise :database_authenticatable, :registerable, :rememberable
end
