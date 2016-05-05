actions :dump, :set, :set_temporary, :revert

property :ilos, Array, :required => true
property :dump_file, String
property :boot_order, Array
property :boot_target, String
property :owner, [String, Integer], default: node['current_user']
property :group, [String, Integer], default: node['current_user']

include IloHelper

action :dump do
  load_sdk(self)
  dumpContent = ""
  ilos.each do |ilo|
    client = build_client(ilo)
    dumpContent = dumpContent + client.get_all_boot_order.to_yaml + "\n"
  end
  file dump_file do
    owner owner
    group group
    content dumpContent
  end
end

action :set do
  load_sdk(self)
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_val = client.get_boot_order
    next if cur_val == boot_order
    converge_by "Set ilo #{ilo} boot order from '#{cur_val.to_s}' to '#{boot_order.to_s}'" do
      client.set_boot_order(boot_order)
    end
  end
end

action :set_temporary do
  load_sdk(self)
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_val = client.get_temporary_boot_order
    next if cur_val == boot_target
    converge_by "Set ilo #{ilo} temporary boot order from '#{cur_val.to_s}' to '#{boot_target.to_s}'" do
      client.set_temporary_boot_order(boot_target)
    end
  end
end

action :revert do
  load_sdk(self)
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_val = client.get_boot_order_baseconfig
    next if cur_val == 'default'
    converge_by "Reverting ilo #{ilo} to default base configuration" do
      client.revert_boot_order
    end
  end
end
