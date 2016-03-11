actions :createUser, :deleteUser, :changePassword
default_action :createUser

property :username, String
property :password, String
property :ilo_names, [Array,Symbol]
include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)
action :createUser do
	if ilo_names.class == Array
		ilo_names.each do |ilo|
			machine  = ilono.select{|k,v| k == ilo}[ilo]
			create_user(machine,username,password)
		end
	else
		ilono.each do |name,site|
			create_user(site, username, password)
	  end
	end
end

action :deleteUser do
	if ilo_names.class == Array
		ilo_names.each do |ilo|
			machine = ilono.select{|k,v| k == ilo}[ilo]
		  delete_user(username,machine)
		end
	else
		ilono.each do |name,site|
			delete_user(username,site)
		end
	end
end

action :changePassword do
	if ilo_names.class == Array
		ilo_names.each do |ilo|
			machine = ilono.select{|k,v| k == ilo}[ilo]
			reset_user_password(machine,username,password)
		end
	else
		ilono.each do |name,site|
			reset_user_password(site, username, password)
	  end
	end
end
