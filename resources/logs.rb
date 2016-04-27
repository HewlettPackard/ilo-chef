actions :clear, :dump

pproperty :ilos, Array, :required => true
property :log_type, String, :required => true
property :severity_level, String, :equal_to => ["OK","Warning","Critical"]
property :dump_file, String, :required => true
property :duration_in_hours, Integer, :required => true, :default => 24

include ClientHelper

action :clear do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      clear_iel_logs(machine) if log_type == 'iel'
      clear_iml_logs(machine) if log_type == 'iml'
    end
  else
    ilono.each do |name,site|
      clear_iel_logs(site) if log_type == 'iel'
      clear_iml_logs(site) if log_type == 'iml'
    end
  end
end

action :dump do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      dump_iel_logs(machine,ilo, severity_level,dump_file,duration_in_hours) if log_type == 'iel'
      dump_iml_logs(machine,ilo,severity_level,dump_file,duration_in_hours) if log_type == 'iml'
    end
  else
    ilono.each do |name,site|
      dump_iel_logs(site,name,severity_level,dump_file,duration_in_hours) if log_type == 'iel'
      dump_iml_logs(site,name,severity_level,dump_file,duration_in_hours) if log_type == 'iml'
    end
  end
end
