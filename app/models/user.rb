class User < ActiveRecord::Base
	has_attached_file :avatar,
	:styles => {:medium => "300x300>", :thumb => "100x100>"}, 
	#:path => ":rails_root/public/system/:class/:id/:style/:basename.:extension",
	:url => "/system/:class/:attachment/:id/:style/:basename.:extension"
	has_many :activities_users
	has_many :activities, :through => :activities_users

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
		if user and user.validate_vote(activity)
		  user.activities << activity
		  user.save!
		end
		return user
	end

  def can_vote
     !self.activities.where("candidato_id is not null").empty? 
  end

  def validate_vote activity
    if activity
      return true
    else
      return false
    end
  end

end
