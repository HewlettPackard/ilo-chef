use_inline_resources
include RestAPI::Helper

action :mount do
  ilos = new_resource.ilo_names
  iso_uri = new_resource.iso_uri
  boot_on_next_server_reset = new_resource.boot_on_next_server_reset
  if ilos.class == Array
    ilos.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      mount_virtual_media(machine,iso_uri,boot_on_next_server_reset)
    end
  else
    ilono.each do |name,site|
			mount_virtual_media(site,iso_uri,boot_on_next_server_reset)
	  end
  end
end
