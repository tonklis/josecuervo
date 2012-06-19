class DisplayController < ApplicationController

	LIMON_ID = 1
	TORONJA_ID = 2
	MANZANA_ID = 3

	def index

	end

	def home

		can_vote = current_user.can_vote
		if not can_vote
			redirect_to votacion_path	
		end

	end

	def votacion
		can_vote = current_user.can_vote
		if can_vote
			redirect_to home_path	
		else
			candidato = current_user.last_vote
			total_votes = Activity.get_total_votes
			total_votes[:activities].each do |activity|
				if activity.candidato.id == LIMON_ID
					@votos_limon = activity.votes
				elsif activity.candidato.id == MANZANA_ID
					@votos_manzana = activity.votes
				elsif activity.candidato.id == TORONJA_ID
					@votos_toronja = activity.votes
				end
			end
			if candidato.id == LIMON_ID
				@clase_limon = "limon_ganador"
				@clase_manzana = "manzana_perdedor"
				@clase_toronja = "toronja_perdedor"
			elsif candidato.id == MANZANA_ID
				@clase_limon = "limon_perdedor"
				@clase_manzana = "manzana_ganador"
				@clase_toronja = "toronja_perdedor"
			elsif candidato.id == TORONJA_ID
				@clase_limon = "limon_perdedor"
				@clase_manzana = "manzana_perdedor"
				@clase_toronja = "toronja_ganador"
			end			
		end
	end

end
