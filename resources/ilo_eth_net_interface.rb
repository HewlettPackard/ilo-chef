actions :use_ntp

property :ilo_names, [Array,Symbol], :required => true
property :value, [TrueClass, FalseClass], :required => true

include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)

action :use_ntp do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      use_ntp_servers(machine,value)
    end
  else
    ilono.each do |name,site|
			use_ntp_servers(site,value)
	  end
  end
end
