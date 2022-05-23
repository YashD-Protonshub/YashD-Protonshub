namespace :expire_reward_points do
  desc "Expire Reward Points"
  task execute: :environment do
    User.update_all(earned_reward_points: 0)
  end
end
