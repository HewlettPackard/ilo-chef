actions :clear, :dump

property :ilo_names, [Array,Symbol], :required => true
property :log_type, String, :required => true
property :severity_level, String, default: "Critical", :equal_to => ["OK","Warning","Critical","any"]
property :filename, String, :required => true
property :duration_in_hours, Integer, :required => true

include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)
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
