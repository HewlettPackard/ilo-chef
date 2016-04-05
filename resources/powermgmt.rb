actions :poweron, :poweroff, :resetsys, :resetilo
property :username, String
property :password, String
property :ilo_names, [Array,Symbol]
include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)

action :poweron do
  if ilo_names.class == Array
		ilo_names.each do |ilo|
			machine  = ilono.select{|k,v| k == ilo}[ilo]
      power_on(machine)
    end
  else
    ilono.each do |name,site|
      power_on(site)
    end
  end
end

action :poweroff do
  if ilo_names.class == Array
		ilo_names.each do |ilo|
			machine  = ilono.select{|k,v| k == ilo}[ilo]
      power_off(machine)
    end
  else
    ilono.each do |name,site|
      power_off(site)
    end
  end
end


action :resetsys do
  if ilo_names.class == Array
		ilo_names.each do |ilo|
			machine  = ilono.select{|k,v| k == ilo}[ilo]
      reset_server(machine)
    end
  else
    ilono.each do |name,site|
      reset_server(site)
    end
  end
end

action :resetilo do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      reset_ilo(machine)
    end
  else
    ilono.each do |name,site|
      reset_ilo(site)
    end
  end
end
