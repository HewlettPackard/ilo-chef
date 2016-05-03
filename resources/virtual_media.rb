actions :mount

property :ilo_names, [Array,Symbol], :required => true
property :iso_uri, String, :required => true, :regex => /^(([^:\/?#]+):)?(\/\/([^\/?#]*))?([^?#]*)(\?([^#]*))?(#(.iso))?/
property :boot_on_next_server_reset, [TrueClass,FalseClass], :default => false

include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)

action :mount do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      mount_virtual_media(machine,iso_uri,boot_on_next_server_reset)
    end
  else
    ilono.each do |name,site|
			mount_virtual_media(site,iso_uri,boot_on_next_server_reset)
	  end
  end
end
