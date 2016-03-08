actions :clear, :dump

attribute :ilo_names, :kind_of => [Array,Symbol], :required => true
attribute :log_type, :kind_of => String, :required => true
attribute :severity_level, :kind_of => String, default: "Critical", :equal_to => ["OK","Warning","Critical","any"]
attribute :filename, :kind_of => String, :required => true
attribute :duration_in_hours, :kind_of => Integer, :required => true
attr_accessor :exists
