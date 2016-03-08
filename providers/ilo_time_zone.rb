use_inline_resources
include RestAPI::Helper

action :set_time_zone do
  ilos = new_resource.ilo_names
  time_zone_index = new_resource.time_zone_index
  if ilos.class == Array
    ilos.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      set_ilo_time_zone(machine,time_zone_index)
    end
  else
    ilono.each do |name,site|
			set_ilo_time_zone(site,time_zone_index)
	  end
  end
end
