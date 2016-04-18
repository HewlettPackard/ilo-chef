actions :set

property :ilos, Array, :required => true
property :asset_tag, String, :required => true

include ClientHelper

action :set do
    ilos.each do |ilo|
      client = build_client(ilo)
      cur_val = client.get_asset_tag
      next if cur_val == asset_tag
      converge_by "Set ilo #{client.host} asset tag from '#{cur_val}' to '#{asset_tag}'" do
        client.set_asset_tag(asset_tag)
      end
    end
end
