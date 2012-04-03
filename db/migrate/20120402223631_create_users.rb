class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :facebook_id
      t.boolean :fan
      t.boolean :new_fan, :default => false

      t.timestamps
    end
  end
end
