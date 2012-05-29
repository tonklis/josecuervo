class AddVotingAppToUser < ActiveRecord::Migration
  def change
    add_column :users, :voting_app, :boolean, :default => false
  end
end
