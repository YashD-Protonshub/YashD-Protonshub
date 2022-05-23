class RewardPoint < ApplicationRecord
  belongs_to :reward_point_transaction, foreign_key: :transaction_id, class_name: "Transaction"
  belongs_to :user

  after_create :check_and_assign_user_tier


  private

  def check_and_assign_user_tier
    # For comparing values we can use dynamic values through models also as we are using from CashRebate
    user_tier = user.tier
    if user.reward_points.sum(:point) > 999 && user.reward_points.sum(:point) < 5000
      user_tier = 1
    elsif user.reward_points.sum(:point) >= 5000
      user_tier = 2
    end
    unless user_tier.eql?(user.tier)
      user.update_column("tier", user_tier)
      if user.tier == User.tiers["Gold"]
        reward = Reward.find_by(name: "4x Airport Lounge Access Reward", active: true)
        can_assign_reward = user.user_rewards.where("reward_id = ? AND DATE(valid_till) > ?", reward.id, Date.today).any?
        user.user_rewards.create(reward_id: reward.id, valid_till: (Date.today + 1.month), availed: false) unless can_assign_reward
      end
    end
  end
end
