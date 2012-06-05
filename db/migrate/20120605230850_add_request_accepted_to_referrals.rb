class AddRequestAcceptedToReferrals < ActiveRecord::Migration
  def change
    add_column :referrals, :request_accepted, :boolean
  end
end
