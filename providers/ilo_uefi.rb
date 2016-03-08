use_inline_resources
include RestAPI::Helper

action :secure_boot do
  ilos = new_resource.ilo_names
  enable = new_resource.enable
  if ilos.class == Array
    ilos.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      enable_uefi_secure_boot(machine, enable)
    end
  else
    ilono.each do |name,site|
      enable_uefi_secure_boot(site, enable)
	  end
  end
end

action :rever_bios do
  ilos = new_resource.ilo_names
  if ilos.class == Array
    ilos.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      revert_bios_settings(machine)
    end
  else
    ilono.each do |name,site|
      revert_bios_settings(site)
    end
  end
end
