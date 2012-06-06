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
    referral.request_accepted = true
    referral.save!

    return referral

  end

end
