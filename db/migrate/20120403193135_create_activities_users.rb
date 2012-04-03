class CreateActivitiesUsers < ActiveRecord::Migration
  def change
    create_table :activities_users do |t|
      t.integer :activity_id
      t.integer :user_id

      t.timestamps
    end
  end
end
