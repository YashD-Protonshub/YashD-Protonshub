class CreateAppConfigurations < ActiveRecord::Migration[6.0]
  def change
    create_table :app_configurations do |t|
      t.float :standard_reward_points
      t.float :standard_amount
      t.string :reward_type
      t.integer :valid_for
      t.timestamps
    end
  end
end
