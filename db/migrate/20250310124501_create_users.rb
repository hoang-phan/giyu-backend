class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :code
      t.integer :birth_day
      t.integer :birth_month
      t.integer :birth_year
      t.date :registration_date
      t.datetime :last_active_at

      t.timestamps
    end
    add_index :users, :code, unique: true
    add_index :users, :phone, unique: true
    add_index :users, :last_active_at
  end
end
