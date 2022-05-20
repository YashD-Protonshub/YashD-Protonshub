class CreateUserRewards < ActiveRecord::Migration[6.0]
  def change
    create_table :user_rewards do |t|
      t.bigint :user_id
      t.bigint :reward_id
      t.boolean :availed
      t.date :valid_till

      t.timestamps
    end
  end
end
