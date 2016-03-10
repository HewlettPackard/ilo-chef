use_inline_resources
include RestAPI::Helper

action :dump do
  ilos = new_resource.ilo_names
  filename = new_resource.filename
  if ilos.class == Array
    ilos.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      dump_computer_details(machine,filename)
    end
  else
    ilono.each do |name,site|
			dump_computer_details(site,filename)
	  end
  end
end
