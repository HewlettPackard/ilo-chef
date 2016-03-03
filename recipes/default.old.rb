#
# Cookbook Name:: iLORestCookbook
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
require 'pry'
#Chef::Resource::Execute.send(:include, RestAPI::Helper)
::Chef::Recipe.send(:include, RestAPI::Helper)

Chef::Config.knife[:ilo_site] = 'https://10.254.37.243'
Chef::Config.knife[:ilo_username] = 'Administrator'
Chef::Config.knife[:ilo_password] = 'Password'
Chef::Config.knife[:ilo_ignore_ssl] = true

#execute "stuff" do
#  sys_info = rest_api(:get, '/rest/v1/systems' )
	#login_to_ilo
#end

#The below will get the user account details from the ILO
#execute "Get ILO User Account"
#  uad = rest_api(:get, '/rest/v1/AccountService/Accounts')
#end
#adminuser=uad["Items"][0]
#adminuser["Password"]="Password123"
#options = {'body' => adminuser}
#adminhref="/rest/v1/AccountService/Accounts/1"
#rest_api(:patch, adminhref, options)

#binding.pry

#puts sys_info
#puts uad



###########
#For Deleting a useraccount#
sys = rest_api(:get, '/rest/v1/systems')
binding.pry
puts sys

