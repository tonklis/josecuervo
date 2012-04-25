class UserMailer < ActionMailer::Base

	default :from => "info@josecuervoespecial.com.mx"

	def send_identification (user, email)
		attachments["credencial.png"] = File.read("#{Rails.root}/public/system/users/avatars/#{user.id}/original/#{user.facebook_id}.png")
		mail(:to => email, :subject => "Tu Credencial del Insistuto Especial")
	end

end
