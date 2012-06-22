class Activity < ActiveRecord::Base
	has_many :activities_users
	has_many :users, :through => :activities_users
  belongs_to :candidato

	def self.get_total_votes

		total_votes = {}
		total_votes[:activities] = []
		activities = Activity.where("candidato_id is not null")
		votes = 0
		activities.each do |activity|
			votes += activity[:votes] = activity.activities_users.count
			voter_ids = ActivitiesUser.find_by_sql("SELECT DISTINCT user_id FROM activities_users WHERE activity_id = #{activity.id} ORDER BY updated_at DESC LIMIT 20")
			activity[:voter_ids] = []
			voter_ids.each do |voter|
				u =  User.find(voter.user_id).facebook_id
					if u.fan and activity[:voter_ids].length < 6
						activity[:voter_ids] <<	u
					end		
				end
			total_votes[:activities] << activity
		end
		total_votes[:votes] = votes
		return total_votes
	end

end
