class User < ApplicationRecord
  has_many :articles_users
  has_many :articles, through: :articles_users
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, presence: true

  def admin?
    role == "admin"
  end

end
