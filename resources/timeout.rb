actions :set_timeout

property :ilo_names, [Array,Symbol]
property :timeout, Fixnum

include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)

action :set_timeout do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      set_ilo_timeout(machine,timeout)
    end
  else
    ilono.each do |name,site|
			set_ilo_timeout(site,timeout)
	  end
  end
end
