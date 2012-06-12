class User < ActiveRecord::Base
	has_attached_file :avatar,
	:styles => {:medium => "300x300>", :thumb => "100x100>"}, 
	#:path => ":rails_root/public/system/:class/:id/:style/:basename.:extension",
	:url => "/system/:class/:attachment/:id/:style/:basename.:extension"
	has_many :activities_users
	has_many :activities, :through => :activities_users
  has_many :referrals, :class_name => "Referral", :foreign_key => :owner_id

	def self.find_or_create_fan facebook_id, is_fan, voting_app

		user = User.find_by_facebook_id(facebook_id)
		if not user
			user = User.new(:facebook_id => facebook_id, :fan => is_fan, :voting_app => voting_app)
			user.save!
		else
      update = false
			if is_fan and not user.fan
				user.fan = true
				user.new_fan = true
				update = true
			end
      if voting_app and not user.voting_app
        user.voting_app = true 
				update = true
      end
      if update
        user.save!
      end
		end

    user[:can_vote] = user.can_vote
		return user
	end

	def self.add_activity facebook_id, activity_id

		user = User.find_by_facebook_id(facebook_id)
		activity = Activity.find(activity_id)
		if activity.candidato_id
				if user and user.can_vote
		 	 		user.activities << activity
		  		user.save!
					user[:voted] = true
				else
					user[:voted] = false
				end
		else
			user.activities << activity
			user.save!
		end
		return user
	end

  def can_vote
    activities = self.activities_users.where("created_at >= ?", Time.now.beginning_of_day)
		activities.each do |au|
			if au.activity.candidato_id != nil
				return false
			end
		end
		return true

  end

end
