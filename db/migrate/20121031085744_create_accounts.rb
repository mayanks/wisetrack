class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :number
      t.string :branch
      t.string :ac_type
      t.integer :balance

      t.timestamps
    end
  end
end
