use_inline_resources
include RestAPI::Helper
::Chef::Provider.send(:include, ILOINFO)


action :createUser do
	username = new_resource.username
	password = new_resource.password
	get_ilos = new_resource.ilo_names
	if get_ilos.class == Array
		get_ilos.each do |ilo|
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
	username = new_resource.username
	ilos = new_resource.ilo_names
	if ilos.class == Array
		ilos.each do |ilo|
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
	username = new_resource.username
	newpassword = new_resource.password
	ilos = new_resource.ilo_names
	if ilos.class == Array
		ilos.each do |ilo|
			machine = ilono.select{|k,v| k == ilo}[ilo]
			reset_user_password(machine,username,newpassword)
		end
	else
		ilono.each do |name,site|
			reset_user_password(site, username, newpassword)
	  end
	end
end
