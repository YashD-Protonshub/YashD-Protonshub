class AssignFreeCoffeeService

  class << self
    def execute(user=nil, for_single_user=false)
      reward = Reward.find_by(name: "Free Coffee", active: true)
      if user.present? && for_single_user
        can_assign_reward = user.user_rewards.where("reward_id = ? AND DATE(valid_till) > ?", reward.id, Date.today).any?
        user.user_rewards.create(reward_id: reward.id, valid_till: (Date.today + 1.month), availed: false) unless can_assign_reward
        return true
      end
      if reward.present? && !for_single_user
        user_with_birthday.each do |user|
          user.user_rewards.create(reward_id: reward.id, valid_till: Date.today.end_of_month, availed: false)
        end
      end
    end

    # Getting users having birthday in current month
    def user_with_birthday
      User.where("CAST(strftime('%m', dob) as INT) = ?", Date.today.month)
    end
  end
end
