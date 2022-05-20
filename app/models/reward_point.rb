class RewardPoint < ApplicationRecord
  belongs_to :reward_point_transaction, foreign_key: :transaction_id, class_name: "Transaction"
  belongs_to :user
end
