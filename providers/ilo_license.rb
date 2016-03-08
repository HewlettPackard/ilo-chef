use_inline_resources
include RestAPI::Helper

action :apply do
  ilos = new_resource.ilo_names
  license_key = new_resource.license_key
  if ilos.class == Array
    ilos.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      apply_license(machine, license_key)
    end
  else
    ilono.each do |name,site|
			apply_license(machine, license_key)
	  end
  end
end
