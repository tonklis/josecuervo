class Referral < ActiveRecord::Base
  belongs_to :owner,  :class_name => "User", :foreign_key => :owner_id
  belongs_to :referred, :class_name => "User", :foreign_key => :referred_id
end
