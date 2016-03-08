use_inline_resources
include RestAPI::Helper

action :fw_up do
  ilos = new_resource.ilo_names
  fw_uri = new_resource.fw_uri
  if ilos.class == Array
    ilos.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      reset_boot_order(machine)
    end
  else
    ilono.each do |name,site|
			reset_boot_order(site)
	  end
  end
end
