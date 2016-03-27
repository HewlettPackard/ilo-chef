property :ilo_name, String, :required => true
property :asset_tag, String, :required => true

include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)
action :set do
  machine  = ilono.select{|k,v| k == ilo_name}[ilo_name]
  set_asset_tag(machine,asset_tag)
end
