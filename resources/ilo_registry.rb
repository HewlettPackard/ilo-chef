actions  :get_registry

property :ilo_name, String, :required => true
property :registry_prefix, String
property :registry_file, String

include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)

action :get_registry do
  machine  = ilono.select{|k,v| k == ilo_name}[ilo_name]
  get_registry(machine,registry_prefix,registry_file)
end
