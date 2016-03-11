actions :dump

property :ilo_names, [Array,Symbol], :required => true
property :dump_file, String, :required => true

include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)
action :dump do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      dump_computer_details(machine,dump_file)
    end
  else
    ilono.each do |name,site|
      dump_computer_details(site,dump_file)
    end
  end
end
