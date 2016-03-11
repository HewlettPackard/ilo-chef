actions :apply

property :ilo_names,[Array,Symbol]
property :license_key, String

include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)
action :apply do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      apply_license(machine, license_key)
    end
  else
    ilono.each do |name,site|
			apply_license(machine, license_key)
	  end
  end
end
