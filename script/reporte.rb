#!/usr/local/bin/ruby
ENV['RAILS_ENV'] = "development"
require '/var/www/vhosts/apps.t2omedia.com.mx/josecuervo/config/environment'
require 'rubygems'
require 'active_support/all'

user_count = User.count
credenciales_count = User.where("avatar_file_name is not null").count
fans_count = User.where("new_fan = 1").count
emails_sent = Activity.find(2).users.count
descargas_made = Activity.find(3).users.count
twitter_shared = Activity.find(4).users.count
credenciales_recientes = []
User.select("id, avatar_file_name").where("avatar_file_name is not null").order("updated_at DESC limit 20").each do |user|
	credenciales_recientes << "http://apps.t2omedia.com.mx/system/users/avatars/#{user.id}/original/#{user.avatar_file_name}"
end
UserMailer.send_report(user_count, credenciales_count, fans_count, emails_sent, descargas_made, twitter_shared, credenciales_recientes,"guillermo.lopez@t2omedia.com.mx").deliver
