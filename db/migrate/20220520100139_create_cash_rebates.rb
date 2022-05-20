class CreateCashRebates < ActiveRecord::Migration[6.0]
  def change
    create_table :cash_rebates do |t|
      t.float :percentage
      t.integer :on_transactions
      t.integer :of_amount

      t.timestamps
    end
  end
end
