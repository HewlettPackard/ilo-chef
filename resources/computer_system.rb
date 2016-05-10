actions :set

property :ilos, Array, :required => true
property :asset_tag, String, :required => true
property :led_state, [String, Symbol], default: 'Lit', equal_to: ['Lit', 'Off', :Lit, :Off], :required => true

include IloHelper

action :set do
  load_sdk(self)
  ilos.each do |ilo|
    client = build_client(ilo)
    raise "Please provide an asset_tag and/or led_state!" unless asset_tag || led_state
    cur_val_asset_tag = client.get_asset_tag
    cur_val_indicator_led = client.get_indicator_led
    unless cur_val_asset_tag == asset_tag
      converge_by "Set ilo #{client.host} asset tag from '#{cur_val_asset_tag}' to '#{asset_tag}'" do
        client.set_asset_tag(asset_tag)
      end
    end
    unless cur_val_indicator_led == led_state
      converge_by "Set ilo #{client.host} indicator led from '#{cur_val_indicator_led}' to '#{led_state}'" do
        client.set_indicator_led(led_state)
      end
    end
  end
end
