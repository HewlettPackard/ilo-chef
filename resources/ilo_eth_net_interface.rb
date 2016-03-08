actions :use_ntp

attribute :ilo_names, :kind_of => [Array,Symbol], :required => true
attribute :value, :kind_of => [TrueClass, FalseClass], :required => true

attr_accessor :exists
