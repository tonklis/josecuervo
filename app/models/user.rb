class User < ActiveRecord::Base
	has_attached_file :avatar,
	:styles => {:medium => "300x300>", :thumb => "100x100>"}, 
	#:path => ":rails_root/public/system/:class/:id/:style/:basename.:extension",
	:url => "/system/:class/:attachment/:id/:style/:basename.:extension"
	has_many :activities_users
	has_many :activities, :through => :activities_users

	def self.find_or_create_fan facebook_id, is_fan

		user = User.find_by_facebook_id(facebook_id)
		if not user
			user = User.new(:facebook_id => facebook_id, :fan => is_fan)
		else
			if is_fan and not user.fan
				user.fan = true
				user.new_fan = true
				user.save!
			end
		end
		return user
	end

	def self.add_activity facebook_id, activity_id

		user = User.find_by_facebook_id(facebook_id)
		activity = Activity.find(activity_id)
		if user and activity
			if user.activities.empty?
				user.activities = []
			end
			user.activities << activity
			user.save!
		end
		return user
	end
end
