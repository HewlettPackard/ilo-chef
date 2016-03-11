actions :reset
property :ilo_names, [Array,Symbol]

include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)
action :reset do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      reset_boot_order(machine)
    end
  else
    ilono.each do |name,site|
			reset_boot_order(site)
	  end
  end
end
