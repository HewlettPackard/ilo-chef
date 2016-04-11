property :ilo_name, String
property :asset_tag, String, :required => true

include RestAPI::Helper
include ::ILOINFO

action :set do
    machine = ilono[ilo_name]
    cur_val = get_asset_tag(machine)
    return if cur_val == asset_tag
    converge_by "Updating asset tag to #{asset_tag}" do
      set_asset_tag(machine,asset_tag)
    end
end
