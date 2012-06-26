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
			activity[:votes] = activity.activities_users.count
			if activity.candidato_id == 1
				activity[:votes] += 83
			elsif activity.candidato_id == 2
				activity[:votes] += 95
			elsif activity.candidato_id == 3
				activity[:votes] += 135
			end
			votes += activity[:votes]

			voter_ids = ActivitiesUser.find_by_sql("SELECT DISTINCT user_id FROM activities_users WHERE activity_id = #{activity.id} ORDER BY updated_at DESC LIMIT 20")
			activity[:voter_ids] = []
			voter_ids.each do |voter|
				u =  User.find(voter.user_id)
					if u.fan and activity[:voter_ids].length < 6
						activity[:voter_ids] <<	u.facebook_id
					end		
				end
			total_votes[:activities] << activity
		end
		total_votes[:votes] = votes
		return total_votes
	end

end
