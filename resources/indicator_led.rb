actions :set

property :ilos, Array, :required => true
property :led_state, [String, Symbol], default: 'Lit', equal_to: ['Lit', 'Off', :Lit, :Off]

include ClientHelper

action :set do
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_val = client.get_indicator_led
    next if cur_val == led_state.to_s
    converge_by "Set ilo #{ilo} indicator LED to '#{led_state}'" do
      client.set_indicator_led(led_state)
    end
  end
end
