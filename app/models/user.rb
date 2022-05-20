class User < ApplicationRecord
  has_many :transactions, dependent: :destroy
  has_many :user_rewards, dependent: :destroy
  has_many :rewards, through: :user_rewards
  has_many :reward_points, dependent: :destroy
  belongs_to :country
  belongs_to :cash_rebate, optional: true

  enum tier: ["Standard", "Gold", "Platinum"]
end
