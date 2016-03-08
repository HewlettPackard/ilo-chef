actions :set

attribute :ilo_names, :kind_of => [Array,Symbol], :required => true
attribute :led_state, :kind_of => String, :required => true, :default => "Lit", :equal_to => ["Lit", "Blinking"	,"Off"]

attr_accessor :exists
