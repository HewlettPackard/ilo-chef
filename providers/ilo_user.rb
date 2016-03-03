use_inline_resources
include RestAPI::Helper


action :createUser do
	username = new_resource.username
	password = new_resource.password
	machine  = new_resource.machine
	get_ilos new_resource.ilo_names
	rest_api(:get, '/rest/v1/AccountService/Accounts', machine)
	newUser = {"UserName" => username, "Password"=> password, "Oem" => {"Hp" => {"LoginName" => username} }}
	options = {'body' => newUser}
	rest_api(:post, '/rest/v1/AccountService/Accounts', machine,  options, )
end

action :deleteUser do
	username = new_resource.username
	machine = new_resource.machine
	accountget = rest_api(:get, '/rest/v1/AccountService/Accounts', machine)
	minhref = adminhref(accountget, username)
	rest_api(:delete,minhref,machine)
end

action :changePassword do
	username = new_resource.username
	newpassword = new_resource.password
	machine = new_resource.machine
	rest_api(:get, '/rest/v1/AccountService/Accounts', machine)
	newPassword = {"Password" => newpassword }
	options = {'body' => newPassword}
	uad = rest_api(:get, '/rest/v1/AccountService/Accounts', machine)
	minhref = adminhref(uad, username )
	rest_api(:patch, minhref, machine, options)
end
