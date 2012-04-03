class ActivitiesUsersJoin < ActiveRecord::Migration
  def up
    create_table 'activities_users', :id => false do |t|
      t.column 'user_id', :integer
      t.column 'activity_id', :integer

      t.timestamps
    end

  end

  def down
    drop_table 'activities_users'
  end
end
