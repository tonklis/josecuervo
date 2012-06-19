class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

	def self.find_for_twitter_oauth(auth_hash)
		user = User.find_by_facebook_id auth_hash["uid"]
		if not user
			user = User.new
			user.facebook_id = auth_hash["uid"]
			user.email = auth_hash["info"]["nickname"]
			user.save!
		end
		return user	
	end

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

	def post_to_twitter(token_hash, candidato)
    consumer = OAuth::Consumer.new(
        'Me9T4gLX50eoE0iUztn5Sw',
        'ZiIUWr6CXJc2DOxkHgXPdIPaa5l36pyDw4aKHb20jg',
        :site => 'http://api.twitter.com'
    )

    access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
		
		message = "Yo #Voto#{candidato.name} como el mejor candidato para mezclar con tequila, emite tu VOTO en: http://jc.in2teck.com/login"
    access_token.request(
        :post,
        'http://api.twitter.com/1/statuses/update.json',
        :status => message
    )

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

	def last_vote
		au = ActivitiesUser.find(:first, :conditions => "user_id = #{self.id} and activities.candidato_id is not null", :joins => " INNER JOIN activities ON activities.id = activities_users.activity_id")

		return Candidato.find(au.activity.candidato_id)
	end

end
