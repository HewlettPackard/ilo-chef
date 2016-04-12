actions :fw_up

property :ilo_names, [Array,Symbol], :required => true
property :fw_uri, String, :required => true
property :fw_version, Float, :required => true

include RestAPI::Helper
include ::ILOINFO
action :fw_up do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono[ilo]
      fail "ilo #{ilo} not defined in configuration!" unless machine
      cur_val = get_fw_version(machine).split(" ").first.to_f
      next if cur_val == fw_version
      converge_by "Upgrading firmware for #{ilo} to #{fw_version} - " do
        fw_upgrade(machine,fw_uri)
      end
    end
  else
    ilono.each do |name,site|
      cur_val = get_fw_version(site).split(" ").first.to_f
      next if cur_val == fw_version
      converge_by "Upgrading firmware for #{ilo} to #{fw_version} - " do
        fw_upgrade(site,fw_uri)
      end
    end
  end
end
