# iLOResourceProvider
##Use-cases covered in this provider Cookbook
##A. User Addition/deletion/Changing Password

###Examples:
###1. User Delete

#####  iLOResourceProvider_ilo_user 'user delete' do
#####    username 'test'
#####    machine machine
#####    action :deleteUser
#####  end


###2. User Addition

##### iLOResourceProvider_ilo_user 'user create' do
#####    username 'test'
#####    password 'password123'
#####    machine machine
#####    ilo_names ["test12"]
#####  end



###3. Change Password

#####  iLOResourceProvider_ilo_user 'user reset password' do
#####    username 'test'
#####    password 'password12'
#####    machine machine
#####    action :changePassword
#####  end



##B. Power On/Off/Reset
###Examples:
###1. Power On System

##### iLOResourceProvider_ilo_powermgmt 'power on' do
#####   machine machine
#####   action :poweron
##### end


###2. Power Off System1.

##### iLOResourceProvider_ilo_powermgmt 'power off' do
#####   machine machine
#####   action :poweron
##### end

###3. Power Reset System

##### iLOResourceProvider_ilo_powermgmt 'resetsys' do
#####   machine machine
#####   action :resetsys
#####  end

