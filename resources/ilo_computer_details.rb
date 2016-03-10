actions :dump

attribute :ilo_names, :kind_of => [Array,Symbol], :required => true
attribute :filename, :kind_of => String, :required => true
attr_accessor :exists
