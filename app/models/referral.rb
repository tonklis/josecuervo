class Referral < ActiveRecord::Base
  belongs_to :owner,  :class_name => "User", :foreign_key => :owner_id

  def self.bulk_create facebook_id, referrals

    user = User.find_by_facebook_id (facebook_id) 
    referrals.each do |referral|

      r = Referral.new(referral)
      r.save!
      user.referrals << r

    end
    user.save!
    return user.referrals

  end

  def self.accept id

    referral = Referral.find(id)
    referral.request_accepted = referral.verify_request
    referral.save!

    return referral

  end

	def verify_request
		Referral.where("referred_id = ? and owner_id <> ? and request_accepted = true and created_at >= ?", self.referred_id, self.owner_id, Time.now.beginning_of_day).empty?
	end

end
