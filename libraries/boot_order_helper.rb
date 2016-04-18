module ILO_SDK
  # Contains helper methods for boot order actions
  module Boot_Order_Helper
    # Dump the boot order
    # @raise [RuntimeError] if the request failed
    # @return [Fixnum] current_boot_order
    def get_all_boot_order
      response = rest_get('/redfish/v1/systems/1/bios/Boot/')
      boot = response_handler(response)
      current_boot_order = {
        @host => boot['PersistentBootConfigOrder']
      }
    end

    # Get the boot order
    # @raise [RuntimeError] if the request failed
    # @return [Fixnum] current_boot_order
    def get_boot_order
      response = rest_get('/redfish/v1/systems/1/bios/Boot/Settings/')
      boot = response_handler(response)['PersistentBootConfigOrder']
    end

    # Set the boot order
    # @param [Fixnum] boot_order
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_boot_order(boot_order)
      newAction = {'PersistentBootConfigOrder' => boot_order}
      response = rest_patch('/redfish/v1/systems/1/bios/Boot/Settings/', body: newAction)
      response_handler(response)
      true
    end

    # Get the temporary boot order
    # @raise [RuntimeError] if the request failed
    # @return [Fixnum] temporary_boot_order
    def get_temporary_boot_order
      response = rest_get('/redfish/v1/Systems/1/')
      response_handler(response)['Boot']['BootSourceOverrideTarget']
    end

    # Set the temporary boot order
    # @param [Fixnum] boot_target
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_temporary_boot_order(boot_target)
      response = rest_get('/redfish/v1/Systems/1/')
      boottargets = response_handler(response)['Boot']['BootSourceOverrideSupported']
      raise "BootSourceOverrideTarget value - #{boot_target} is not supported. Valid values are: #{boottargets}" if not boottargets.include? boot_target
      newAction = {"Boot" => {"BootSourceOverrideTarget" => boot_target}}
      response = rest_patch('/redfish/v1/Systems/1/', body: newAction)
      response_handler(response)
      true
    end

    # Get the boot order base config
    # @raise [RuntimeError] if the request failed
    # @return [Fixnum] boot_order_baseconfig
    def get_boot_order_baseconfig
      response = rest_get('/redfish/v1/Systems/1/bios/Boot/Settings/')
      response_handler(response)["BaseConfig"]
    end

    # Revert the boot order
    # @raise [RuntimeError] if the request failed
    # @return [Fixnum] true
    def revert_boot_order
      newAction = {"BaseConfig" => "default"}
      response = rest_patch('/redfish/v1/Systems/1/bios/Boot/Settings/', body: newAction)
      response_handler(response)
      true
    end
  end
end
