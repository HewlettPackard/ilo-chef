actions :poweron, :poweroff, :resetsys
default_action :createUser

attribute :username, :kind_of => String
attribute :password, :kind_of => String
attribute :ilo_names, :kind_of => [Array,Symbol]

attr_accessor :exists
