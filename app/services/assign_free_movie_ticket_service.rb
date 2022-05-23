class AssignFreeMovieTicketService

  class << self
    def execute(user)
      if check_eligibity_for_reward(user)
        # For now we are using name to find reward. We can refactor model Reward to fetch dynamically.
        reward = Reward.find_by(name: "Free Movie Ticket", active: true)
        can_assign_reward = user.user_rewards.where("reward_id = ? AND DATE(valid_till) > ?", reward.id, Date.today).any?
        user.user_rewards.create(reward_id: reward.id, valid_till: (Date.today + 1.month), availed: false) unless can_assign_reward
      end
    end

    def check_eligibity_for_reward(user)
      # Here we can also use dynamic values like no of days by storing it in db model like AppConfiguration or Rewards.
      start_date = (Date.today - 60.days)
      end_date = Date.today
      if (user.created_at.to_date >= start_date) && (user.created_at.to_date <= end_date)
        user.transactions.sum(:amount) > 1000
      end
    end
  end
end
