actions :set_time_zone, :set_ntp_servers, :use_ntp

property :ilo_names, [Array,Symbol]
property :time_zone, String
property :ntp_servers, Array
property :value, [TrueClass, FalseClass], :required => true


include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)

action :set_time_zone do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      set_ilo_time_zone(machine,time_zone)
    end
  else
    ilono.each do |name,site|
			set_ilo_time_zone(site,time_zone)
	  end
  end
end

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

action :set_ntp_servers do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      set_ntp_servers(machine,ntp_servers)
    end
  else
    ilono.each do |name,site|
      set_ntp_servers(site,ntp_servers)
    end
  end
end
