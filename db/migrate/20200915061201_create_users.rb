class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.boolean :admin
      t.boolean :blocked
      t.string :avatar_url

      t.timestamps
    end
  end
end
