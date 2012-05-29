class UserMailer < ActionMailer::Base

	default :from => "info@josecuervoespecial.com.mx"

	def send_identification (user, email)
		attachments["credencial.png"] = File.read("#{Rails.root}/public/system/users/avatars/#{user.id}/original/#{user.facebook_id}.png")
		mail(:to => email, :subject => "Credencial I.E.E. Cuervo Especial")
	end

	def send_report(user_count, credenciales_count, fans_count, emails_sent, descargas_made, twitter_shared, credenciales_recientes, email)
		mail(:to => email, :subject => "Reporte") do |format|
			format.text { render :text => "usuarios totales: #{user_count}\ncredenciales totales: #{credenciales_count}\nfans nuevos: #{fans_count}\nemails enviados: #{emails_sent}\ndescargas realizadas: #{descargas_made}\ntwitts compartidos: #{twitter_shared}\ncredenciales recientes: #{credenciales_recientes} "}
		end
	end

end
