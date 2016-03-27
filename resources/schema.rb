actions  :get_schema

property :ilo_name, String, :required => true
property :schema_prefix, String
property :schema_file, String

include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)

action :get_schema do
  machine  = ilono.select{|k,v| k == ilo_name}[ilo_name]
  get_schema(machine,schema_prefix,schema_file)
end
