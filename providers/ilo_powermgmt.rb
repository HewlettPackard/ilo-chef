use_inline_resources
include RestAPI::Helper

action :poweron do
  ilos = new_resource.ilo_names
  if ilos.class == Array
		ilos.each do |ilo|
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
  ilos = new_resource.ilo_names
  if ilos.class == Array
    ilos.each do |ilo|
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
  ilos = new_resource.ilo_names
  if ilos.class == Array
		ilos.each do |ilo|
			machine  = ilono.select{|k,v| k == ilo}[ilo]
      reset_server(machine)
    end
  else
    ilono.each do |name,site|
      reset_server(site)
    end
  end
end
