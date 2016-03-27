actions :reset, :get, :change, :temporary_change
property :ilo_names, [Array,Symbol]
property :ilo_name, String
property :boot_order_file, String
property :new_boot_order, Array
property :boot_target, String

include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)
action :reset do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      reset_boot_order(machine)
    end
  else
    ilono.each do |name,site|
			reset_boot_order(site)
	  end
  end
end

action :get do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      get_boot_order(machine, boot_order_file)
    end
  else
    ilono.each do |name,site|
      get_boot_order(site, boot_order_file)
    end
  end
end

action :change do
  machine  = ilono.select{|k,v| k == ilo_name}[ilo_name]
  change_boot_order(machine,new_boot_order)
end

action :temporary_change do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      change_temporary_boot_order(machine, boot_target)
    end
  else
    ilono.each do |name,site|
      change_temporary_boot_order(site, boot_target)
    end
  end
end
