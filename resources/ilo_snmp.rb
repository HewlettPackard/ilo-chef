actions :configure

property :ilo_names, [Array,Symbol], :required => true
property :snmp_mode, String, :default => 'Agentless', :equal_to => ['Agentless', 'PassThru']
property :snmp_alerts, [TrueClass, FalseClass], :default => false

include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)

action :configure do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      configure_snmp(machine,snmp_mode,snmp_alerts)
    end
  else
    ilono.each do |name,site|
			configure_snmp(site,snmp_mode, snmp_alerts)
	  end
  end
end
