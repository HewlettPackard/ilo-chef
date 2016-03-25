actions :get_bios

property :ilo_names, [Array,Symbol]

include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)
action :get_bios do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      get_bios_resource(machine)
    end
  else
    ilono.each do |name,site|
      get_bios_resource(site)
    end
  end
end
