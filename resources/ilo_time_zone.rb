actions :set_time_zone

property :ilo_names, [Array,Symbol]
property :time_zone, String

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
