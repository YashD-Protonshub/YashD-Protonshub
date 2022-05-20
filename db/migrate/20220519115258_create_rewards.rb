class CreateRewards < ActiveRecord::Migration[6.0]
  def change
    create_table :rewards do |t|
      t.string :name
      t.float :cash_rebate
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
