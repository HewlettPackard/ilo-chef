use_inline_resources
include RestAPI::Helper

action :set do
  ilos = new_resource.ilo_names
  led_state = new_resource.led_state
  if ilos.class == Array
    ilos.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      set_led_light(machine,led_state)
    end
  else
    ilono.each do |name,site|
			set_led_light(site,led_state)
	  end
  end
end
