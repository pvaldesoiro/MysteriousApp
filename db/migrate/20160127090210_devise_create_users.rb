class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :username,           null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.boolean :admin,             null: false, default: false

      t.datetime :remember_created_at

      t.timestamps null: false
    end

    add_index :users, :username, unique: true
  end
end
