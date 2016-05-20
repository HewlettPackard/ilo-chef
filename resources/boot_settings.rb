actions :revert, :set, :dump

action_class do
  include IloHelper
end

property :ilos, Array, :required => true
property :dump_file, String
property :boot_order, Array
property :boot_target, String
property :owner, [String, Integer], default: node['current_user']
property :group, [String, Integer], default: node['current_user']

action :revert do
  load_sdk
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_val = client.get_boot_baseconfig
    next if cur_val == 'default'
    converge_by "Reverting ilo #{ilo} to default boot base configuration" do
      client.revert_boot
    end
  end
end

action :set do
  load_sdk
  ilos.each do |ilo|
    client = build_client(ilo)
    configs = {
      'boot_order' => {
        'current' => client.get_boot_order,
        'new' => boot_order
      },
      'temporary_boot_order' => {
        'current' => client.get_temporary_boot_order,
        'new' => boot_target
      }
    }
    configs.each do |key, value|
      next if value['current'] == value['new']
      next if value['new'] == nil
      if key == 'boot_order'
        converge_by "Set ilo #{client.host} Boot Order from '#{value['current']}' to '#{value['new']}'" do
          client.set_boot_order(boot_order)
        end
      end
      if key == 'temporary_boot_order'
        converge_by "Set ilo #{client.host} Temporary Boot Order from '#{value['current']}' to '#{value['new']}'" do
          client.set_temporary_boot_order(boot_target)
        end
      end
    end
  end
end

action :dump do
  load_sdk
  dumpContent = ""
  ilos.each do |ilo|
    client = build_client(ilo)
    boot_order = {client.host => client.get_boot_order}
    dumpContent = dumpContent + boot_order.to_yaml + "\n"
  end
  file dump_file do
    owner owner
    group group
    content dumpContent
  end
end
