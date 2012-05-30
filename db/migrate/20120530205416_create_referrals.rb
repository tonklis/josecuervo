class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.integer :owner_id
      t.integer :referred_id, :limit => 8

      t.timestamps
    end
  end
end
