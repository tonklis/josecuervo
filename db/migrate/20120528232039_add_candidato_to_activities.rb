class AddCandidatoToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :candidato_id, :integer
  end
end
