actions :mount

attribute :ilo_names, :kind_of => [Array,Symbol], :required => true
attribute :iso_uri, :kind_of => String, :required => true
attribute :boot_on_next_server_reset, :kind_of => [TrueClass,FalseClass], :default => false

attr_accessor :exists
