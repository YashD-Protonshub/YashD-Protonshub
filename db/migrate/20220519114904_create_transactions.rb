class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.float :amount
      t.bigint :user_id
      t.bigint :country_id

      t.timestamps
    end
  end
end
