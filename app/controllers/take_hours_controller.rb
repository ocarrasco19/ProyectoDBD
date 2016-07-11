class TakeHoursController < ApplicationController

#mostrar bloques de atención de los doctores
  def index
	##para saber si busca por especialidad o por nombre
	if !params[:id].present? #si no está id, se busca por nombre

		#buscar el doctor con los nombres ingresados
		@doctor = User.find_by_sql("select * from users inner join doctors on doctors.user_id = users.user_id where user_NAMES = '#{params[:nombre]}'")

		if @doctor.count == 0
			redirect_to search_medics_index_path
		end

		#bloques de atención del doctor
		@abs = AttentionBlock.find_by_sql("select * from attention_blocks ab inner join doctors d on d.doctor_id = ab.doctor_id inner join users u on u.user_id = d.user_id where u.user_NAMES = '#{params[:nombre]}'")
	else
		#se busca por id
		@doctor = User.find_by_sql("select * from users where users.user_id = '#{params[:id]}'")
		@abs = AttentionBlock.find_by_sql("select * from attention_blocks ab where ab.doctor_id = '#{params[:id]}'")


	end

	#especialidades de los bloques
	@specs = Specialty.find_by_sql("select * from specialties")
  end


#buscar por especialidad
  def show
	#buscar especialidad
	@spec = Specialty.find_by_sql("select * from specialties where SPEC_NAME = '#{params[:specialty][:SPEC_NAME]}'")
	
	#buscar doctores con esa especialidad
	@doctors = User.find_by_sql("select * from users inner join doctors d on d.user_id = users.user_id inner join doctor_specialties ds on ds.doctor_id = d.doctor_id where ds.SPEC_ID = '#{@spec[0].SPEC_ID}'")	

  end

  #cuando se quiere agendar una hora
  def show2
	if user_signed_in?
		#buscar al paciente
		@paciente = Patient.find_by_sql("select * from patients where patients.user_id = '#{current_user.user_id}'")

		#ver si hora está creada
		@hr =  ReservedHour.find_by_sql("select * from reserved_hours rh where rh.AB_ID = '#{params[:ab_id]}'")
		
		#si existe, ver si su hora empiza a la misma hora, si es 			así, está tomada
		#hr = horas dentro del mismo bloque
		if @hr != nil #si existe
		  @hr.each do |f|
       		    if f.RH_START_TIME.to_s == params[:hora_inicio]
			flash[:alert] = "Hora ya está tomada"
		 	redirect_to(:back)	
		    end
		  end		
		end

		#doctor
		@doctor = User.find_by_sql("select * from users where user_id = '#{params[:user_id]}'")

		#bloque de atención
		@ab = AttentionBlock.find_by_sql("select * from attention_blocks ab where ab.AB_ID = '#{params[:ab_id]}'")

		@hora_inicio = params[:hora_inicio]
		@hora_fin = params[:hora_fin]

		@spec = Specialty.find_by_sql("select * from specialties where specialties.SPEC_ID = '#{@ab[0].SPEC_ID}'")

	else
		flash[:alert] = "Debes haber iniciado sesión para reservar una hora"
		redirect_to new_user_session_path
	end
  end

  def show3
	##crear hora confirmada
	ReservedHour.crear(params[:patient_id], params[:ab_id], params[:hora_inicio], params[:hora_fin])
	redirect_to welcome_index_path
  end
end
