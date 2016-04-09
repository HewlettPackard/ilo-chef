actions :set_timeout

property :ilo_names, [Array,Symbol]
property :timeout, Fixnum

include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)

action :set_timeout do
  if ilo_names.class == Array
    ilo_names.each do |ilo|
      machine  = ilono.select{|k,v| k == ilo}[ilo]
      oldTimeout = get_ilo_timeout(machine)
      if oldTimeout != timeout
        converge_by "Setting iLO #{ilo} timeout from #{oldTimeout} to #{timeout} minutes" do
          set_ilo_timeout(machine,timeout)
        end
      end
    end
  else
    ilono.each do |name,site|
      oldTimeout = get_ilo_timeout(machine)
      if oldTimeout != timeout
        converge_by "Setting iLO #{ilo} timeout from #{oldTimeout} to #{timeout} minutes" do
          set_ilo_timeout(site,timeout)
        end
      end
	  end
  end
end
