# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

["India", "USA", "China", "UK", "Canada"].each do |country|
  Country.find_or_create_by(name: country)
  puts "Created Country #{country}"
end

["Free Coffee", "Free Movie Ticket"].each do |reward|
  Reward.find_or_create_by(name: reward)
  puts "Created Reward #{reward}"
end

CashRebate.find_or_create_by(percentage: 5, on_transactions: 10, of_amount: 100)


AppConfiguration.find_or_create_by(reward_type: AppConfiguration::RECEIVE_POINTS_FOR_DOMESTIC, standard_reward_points: 10, standard_amount: 100, valid_for: 0)
AppConfiguration.find_or_create_by(reward_type: AppConfiguration::RECEIVE_POINTS_FOR_INTERNATIONAL, standard_reward_points: 20, standard_amount: 100, valid_for: 1)