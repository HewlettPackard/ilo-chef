actions :secure_boot, :revert_bios

attribute :ilo_names, :kind_of => [Array,Symbol]
attribute :enable, :kind_of => [TrueClass, FalseClass], default: false

attr_accessor :exists
