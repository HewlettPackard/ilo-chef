# (c) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.


# Managing iLO user accounts

# List of iLOs (replace with your own hostnames and credentials):
my_ilos = [
  { host: 'ilo1.example.com', user: 'Admin', password: 'secret123' },
  { host: 'ilo2.example.com', user: 'Admin', password: 'secret456' }
]

# Example: Create a user (bob) and set the login password
# Note that we don't need to specify the action, because it will use the :create action by default.
# Also, we can use the resource name to set the username parameter. Since we don't specify any
# privilege parameters, they will not be modified; if the user needs to be created, it will use
# the default permissions on the iLO.
ilo_user 'bob' do
  ilos my_ilos
  password 'password123'
end

# Example: Update a user's password
# Note that we still don't need to specify the action. It will use the :create action by default,
# which will also modify existing users, not just create new ones. Since we already have a 'bob'
# ilo_user resource, we'll need to use a different resource name here: 'update bob'. But since
# the iLO user that we want to manage is 'bob', not 'update bob', we need to specify a username
# property to identify the correct user. We just specify the new password, and it will get set.
ilo_user 'update bob' do
  ilos my_ilos
  username 'bob'
  password 'new_password456'
end

# Example: Set a user's privileges
# Again, using the default :create action, we can modify a user's permissions.
# Note that we didn't specify the user's password here, so this resource relies on the user already
# existing; it won't be able to create the user without specifying the password.
ilo_user 'set privileges for bob' do
  ilos my_ilos
  username 'bob'
  login_priv true
  remote_console_priv false
  user_config_priv true
  virtual_media_priv false
  virtual_power_and_reset_priv true
  ilo_config_priv false
end

# Example: Update a user's privileges
# You guessed it! To update a user's privileges, all we need to do are set the new values exactly
# the same way we did before. Note that this time we only specified a subset of the privileges; only
# the privileges that we specify will be modified. All other privileges will be left alone.
ilo_user 'update privileges for bob' do
  ilos my_ilos
  username 'bob'
  remote_console_priv true
  ilo_config_priv true
end

# Example: Delete a user
# The description really should say "make sure a user doesn't exist", because this isn't scripting;
# we aren't making a DELETE REST call on the user 'jane'. What actually happens is Chef will check
# if a user name 'jane' exists; if not, nothing needs to be done. If the account does exist, it will
# be deleted.
ilo_user 'jane' do
  ilos my_ilos
  action :delete
end

# Example: Tying it all together
# We've gone through quite a few different examples, each a little different. However, you really
# only should have 1 resource to manage a user. Put in as few parameters as you'd like, or specify
# them all; it doesn't matter. But for whatever you do specify, Chef will ensure it matches on the
# iLO. Here we'll manage another user, 'jerry', and specify all the parameters. If jerry doesn't
# exist, his account will get created; if it does exist, it will get updated to match what we defined.
ilo_user 'jerry' do
  ilos my_ilos
  password 'password123'
  login_priv true
  remote_console_priv false
  user_config_priv true
  virtual_media_priv false
  virtual_power_and_reset_priv true
  ilo_config_priv false
end
