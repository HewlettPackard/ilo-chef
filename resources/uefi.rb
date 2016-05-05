actions :secure_boot

property :ilos, Array, :required => true
property :enable, [TrueClass, FalseClass], default: false

include IloHelper
#The Unified Extensible Firmware Interface (UEFI) provides a higher level of security by protecting against unauthorized Operating Systems
# and malware rootkit attacks, validating that only authenticated ROMs, pre-boot applications, and OS boot loaders that have been
# digitally signed are run.
action :secure_boot do
  load_sdk(self)
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_val = client.get_uefi_secure_boot
    next if cur_val == enable
    converge_by "Set ilo #{client.host} secure boot to '#{enable.to_s}'" do
      client.set_uefi_secure_boot(enable)
    end
  end
end
