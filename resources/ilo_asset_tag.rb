actions :set

attribute :ilo_name, :kind_of => String, :required => true
attribute :asset_tag, :kind_of => String, :required => true

attr_accessor :exists
