class AttentionBlock < ActiveRecord::Base
  def self.deshabilitar ab_id
	sql = "UPDATE attention_blocks SET AB_AVAILABLE = false WHERE AB_ID = '#{ab_id}'"
	ActiveRecord::Base.connection.execute(sql)
  end

  def self.crear(doctor_id, fecha, hora_inicio, hora_fin, eficiencia, spec_id)
	fecha2 = fecha
	hora_inicio2 = Time.parse(hora_inicio).to_s(:db)
	hora_fin2 = Time.parse(hora_fin).to_s(:db)
	created = Time.zone.now.to_s(:db)
	updated = Time.zone.now.to_s(:db)
	sql = "INSERT INTO attention_blocks(doctor_id, SPEC_ID, AB_DATE, AB_START_TIME, AB_FINISH_TIME, AB_EFFICIENCY, AB_AVAILABLE, created_at, updated_at) VALUES('#{doctor_id}', '#{spec_id}', '#{fecha2}', '#{hora_inicio2}', '#{hora_fin2}', '#{eficiencia}', true, '#{created}', '#{updated}')"
	ActiveRecord::Base.connection.execute(sql)
  end
end
