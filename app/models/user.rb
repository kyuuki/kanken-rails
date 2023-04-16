class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_clients
  has_many :clients, through: :user_clients

  def self.ransackable_attributes(auth_object = nil)
    ["email"]
  end
end
