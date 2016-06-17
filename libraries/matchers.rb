if defined?(ChefSpec)
  ChefSpec::Runner.define_runner_method(:ilo_account_service)

  ilo_resources = {
    ilo_account_service:          [:create, :delete, :changePassword],
    ilo_bios:                     [:revert, :set],
    ilo_boot_settings:            [:revert, :set, :dump],
    ilo_chassis:                  [:dump],
    ilo_computer_details:         [:dump],
    ilo_date_time:                [:set],
    ilo_firmware_update:          [:upgrade],
    ilo_log_entry:                [:clear, :dump],
    ilo_manager_network_protocol: [:set],
    ilo_power:                    [:poweron, :poweroff, :resetsys, :resetilo],
    ilo_secure_boot:              [:secure_boot],
    ilo_service_root:             [:dump],
    ilo_snmp_service:             [:configure],
    ilo_virtual_media:            [:insert, :eject]
  }

  ilo_resources.each do |resource_type, actions|
    actions.each do |action|
      method_name = "#{action}_#{resource_type}"
      define_method(method_name) do |resource_name|
        ChefSpec::Matchers::ResourceMatcher.new(resource_type, action, resource_name)
      end
    end
  end
end
