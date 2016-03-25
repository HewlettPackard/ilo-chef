actions :set_time_zone, :set_ntp_servers

property :ilo_names, [Array,Symbol]
property :time_zone, String
property :ntp_servers, Array

include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)

action :set_time_zone do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      set_ilo_time_zone(machine,time_zone)
    end
  else
    ilono.each do |name,site|
			set_ilo_time_zone(site,time_zone)
	  end
  end
end

action :set_ntp_servers do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      set_ntp_servers(machine,ntp_servers)
    end
  else
    ilono.each do |name,site|
      set_ntp_servers(site,ntp_servers)
    end
  end
end
