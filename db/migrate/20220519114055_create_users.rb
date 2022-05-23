class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.date :dob
      t.string :email
      t.integer :tier, default: 0
      t.bigint :country_id
      t.integer :cash_rebate_id

      t.timestamps
    end
  end
end
