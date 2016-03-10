use_inline_resources
include RestAPI::Helper

action :set do
  ilo = new_resource.ilo_name
  asset_tag = new_resource.asset_tag
  machine  = ilono.select{|k,v| k == ilo}[ilo]
  set_asset_tag(machine,asset_tag)
end
