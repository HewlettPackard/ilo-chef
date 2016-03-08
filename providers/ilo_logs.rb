use_inline_resources
include RestAPI::Helper

action :clear do
  ilos = new_resource.ilo_names
  log_type = new_resource.log_type
  if ilos.class == Array
    ilos.each do |ilo|
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
  ilos = new_resource.ilo_names
  log_type = new_resource.log_type
  severity = new_resource.severity_level
  filename = new_resource.filename
  duration = new_resource.duration_in_hours
  if ilos.class == Array
    ilos.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      dump_iel_logs(machine,ilo, severity,filename,duration) if log_type == 'iel'
      dump_iml_logs(machine,ilo,severity,filename,duration) if log_type == 'iml'
    end
  else
    ilono.each do |name,site|
      dump_iel_logs(site,name,severity,filename,duration) if log_type == 'iel'
      dump_iml_logs(site,name,severity,filename,duration) if log_type == 'iml'
    end
  end
end
