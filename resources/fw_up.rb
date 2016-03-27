actions :fw_up

property :ilo_names, [Array,Symbol], :required => true
property :fw_uri, String, :required => true

include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)
action :fw_up do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      fw_upgrade(machine,fw_uri)
    end
  else
    ilono.each do |name,site|
			fw_upgrade(site,fw_uri)
	  end
  end
end
