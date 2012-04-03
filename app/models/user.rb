class User < ActiveRecord::Base
	has_attached_file :avatar,
	:styles => {:medium => "300x300>", :thumb => "100x100>"}, 
	#:path => ":rails_root/public/system/:class/:id/:style/:basename.:extension",
	:url => "/system/:class/:attachment/:id/:style/:basename.:extension"
	has_and_belongs_to_many :activities
end
