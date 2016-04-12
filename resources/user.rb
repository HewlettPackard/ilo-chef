actions :createUser, :deleteUser, :changePassword
default_action :createUser

property :username, String
property :password, String
property :ilo_names, [Array,Symbol]
include RestAPI::Helper
include ::ILOINFO
action :createUser do
	if ilo_names.class == Array
		ilo_names.each do |ilo|
			machine  = ilono[ilo]
			fail "ilo #{ilo} not defined in configuration!" unless machine
			next if get_users(machine).include?(username)
			converge_by "Creating user #{username} for #{ilo} - " do
				create_user(machine,username,password)
			end
		end
	else
		ilono.each do |name,site|
			next if get_users(site).include?(username)
			converge_by "Creating user #{username} for #{site} - " do
				create_user(site, username, password)
			end
		end
	end
end

action :deleteUser do
	if ilo_names.class == Array
		ilo_names.each do |ilo|
			machine = ilono[ilo]
			fail "ilo #{ilo} not defined in configuration!" unless machine
			next if !get_users(machine).include?(username)
			converge_by "Deleting user #{username} from #{ilo} - " do
				delete_user(username,machine)
			end
		end
	else
		ilono.each do |name,site|
			next if get_users(site).include?(username)
			converge_by "Deleting user #{username} from #{site} - " do
				delete_user(username,site)
			end
		end
	end
end

action :changePassword do
	if ilo_names.class == Array
		ilo_names.each do |ilo|
			machine = ilono[ilo]
			fail "ilo #{ilo} not defined in configuration!" unless machine
			converge_by "Changing password for #{username} in #{ilo}- " do
			reset_user_password(machine,username,password)
		end
		end
	else
		ilono.each do |name,site|
			converge_by "Changing password for #{username} in #{site}- " do
			reset_user_password(site, username, password)
		end
	  end
	end
end
