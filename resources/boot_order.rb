actions :revert, :get, :change, :temporary_change
property :ilos, Array, :required => true
property :boot_order_file, String
property :new_boot_order, Array
property :boot_target, String

include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)

action :get do
  ilos.each do |ilo|
    machine  = ilono.select{|k,v| k == ilo}[ilo]
    converge_by "Getting boot order and placing in #{boot_order_file}" do
      get_boot_order(machine, boot_order_file)
    end
  end
end

action :change do
  ilos.each do |ilo|
    machine  = ilono.select{|k,v| k == ilo}[ilo]
    old_boot_order = get_boot_order(machine, boot_order_file)[machine["ilo_site"]]
    if not old_boot_order == new_boot_order
      converge_by "Setting boot order from #{old_boot_order.to_s} to #{new_boot_order.to_s}" do
        boot_order_change(machine, new_boot_order)
        reset_server(machine)
      end
    end
  end
end

action :temporary_change do
  ilos.each do |ilo|
    machine  = ilono.select{|k,v| k == ilo}[ilo]
    old_target = get_temporary_boot_order(machine)
    if not old_target == boot_target
      converge_by "Setting temporary boot order from #{old_target} to #{boot_target}" do
        boot_order_change_temporary(machine, boot_target)
      end
    end
  end
end

action :revert do
  ilos.each do |ilo|
    machine  = ilono.select{|k,v| k == ilo}[ilo]
    if not get_boot_order_baseconfig(machine) == "default"
      converge_by "Reverting boot order to default" do
        boot_order_revert(machine)
      end
    end
  end
end
