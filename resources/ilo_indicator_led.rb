actions :set

property :ilo_names, [Array,Symbol], :required => true
property :led_state, String, :required => true, :default => "Lit", :equal_to => ["Lit", "Blinking"	,"Off"]

include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)

action :set do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      set_led_light(machine,led_state)
    end
  else
    ilono.each do |name,site|
			set_led_light(site,led_state)
	  end
  end
end
