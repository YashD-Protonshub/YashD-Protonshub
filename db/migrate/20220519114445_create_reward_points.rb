class CreateRewardPoints < ActiveRecord::Migration[6.0]
  def change
    create_table :reward_points do |t|
      t.float :point
      t.bigint :transaction_id
      t.bigint :user_id

      t.timestamps
    end
  end
end
