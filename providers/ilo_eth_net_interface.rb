use_inline_resources
include RestAPI::Helper

action :use_ntp do
  ilos = new_resource.ilo_names
  value = new_resource.value
  if ilos.class == Array
    ilos.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      use_ntp_servers(machine,value)
    end
  else
    ilono.each do |name,site|
			use_ntp_servers(site,value)
	  end
  end
end
