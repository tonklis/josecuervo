class Referral < ActiveRecord::Base
  belongs_to :owner,  :class_name => "User", :foreign_key => :owner_id

  def self.bulk_create facebook_id, referrals

    user = User.find_by_facebook_id (facebook_id) 
    referrals.each do |referral|

      r = Referral.new(referral)
			r.request_accepted = false
      r.save!
      user.referrals << r

    end
    user.save!
    return user.referrals

  end

  def self.accept facebook_id, referred_id

    user = User.find_by_facebook_id (facebook_id) 

    referral = Referral.where("request_accepted = ? and owner_id = ? and referred_id = ?", false, user.id, referred_id).order("updated_at DESC").first
		if referral
    	referral.request_accepted = true
    	referral.save!
		end
    return referral
  end

end
