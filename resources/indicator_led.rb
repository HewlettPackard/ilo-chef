actions :set

property :ilo_names, [Array,Symbol], :required => true
property :led_state, String, required: true, default: "Lit", equal_to: ["Lit","Off"]

include RestAPI::Helper
include ::ILOINFO

action :set do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine = ilono[ilo]
      fail "ilo #{ilo} not defined in configuration!" unless machine
      cur_val = get_indicator_led(machine)
      next if cur_val == led_state.to_s
      converge_by "Set ilo #{ilo} indicator LED to '#{led_state}'" do
        set_indicator_led(machine, led_state)
      end
    end
  else
    ilono.each do |name, data|
      cur_val = get_indicator_led(data)
      next if cur_val == led_state.to_s
      converge_by "Set ilo #{name} indicator LED to '#{led_state}'" do
        set_indicator_led(data, led_state)
      end
    end
  end
end
