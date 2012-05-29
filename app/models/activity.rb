class Activity < ActiveRecord::Base
	has_many :activities_users
	has_many :users, :through => :activities_users
  belongs_to :candidato
end
