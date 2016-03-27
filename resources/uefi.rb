actions :secure_boot, :revert_bios

property :ilo_names, [Array,Symbol]
property :enable, [TrueClass, FalseClass], default: false

include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)
action :secure_boot do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      enable_uefi_secure_boot(machine, enable)
    end
  else
    ilono.each do |name,site|
      enable_uefi_secure_boot(site, enable)
	  end
  end
end

action :revert_bios do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      revert_bios_settings(machine)
    end
  else
    ilono.each do |name,site|
      revert_bios_settings(site)
    end
  end
end
