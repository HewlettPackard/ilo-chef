actions :secure_boot

property :ilo_names, [Array,Symbol]
property :enable, [TrueClass, FalseClass], default: false

include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)
#The Unified Extensible Firmware Interface (UEFI) provides a higher level of security by protecting against unauthorized Operating Systems
# and malware rootkit attacks, validating that only authenticated ROMs, pre-boot applications, and OS boot loaders that have been
# digitally signed are run.
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
