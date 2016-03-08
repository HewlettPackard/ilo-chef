actions :fw_up

attribute :ilo_names, :kind_of => [Array,Symbol], :required => true
attribute :fw_uri, :kind_of => String, :required => true

attr_accessor :exists
