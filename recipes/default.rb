#
# Cookbook Name:: iLORestCookbook
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
require 'pry'
#Chef::Resource::Execute.send(:include, RestAPI::Helper)
#To Add user on all the 
#
::Chef::Recipe.send(:include, RestAPI::Helper)
::Chef::Recipe.send(:include, ILOINFO)

#ilono.each do |ilo, machine|
#  iLOResourceProvider_ilo_user 'user reset password' do
#    username 'test'
#    password 'password12'
#    machine machine
#    action :changePassword
#  end
#end

#ilono.each do |ilo, machine|
#  iLOResourceProvider_ilo_user 'user delete' do
#    username 'test'
#    machine machine
#    action :deleteUser
#  end
#end

#ilono.each do |ilo, machine|
#  iLOResourceProvider_ilo_user 'user create' do
#    username 'test'
#    password 'password123'
#    machine machine
#    ilo_names ["test12"]
#  end
#end


#ilono.each do |ilo, machine|
# iLOResourceProvider_ilo_powermgmt 'power on' do
#   machine machine
#   action :poweron
# end
#end

#ilono.each do |ilo, machine|
# iLOResourceProvider_ilo_powermgmt 'power off' do
#   machine machine
#   action :poweron
# end
#end

ilono.each do |ilo, machine|
 iLOResourceProvider_ilo_powermgmt 'resetsys' do
   machine machine
   action :poweron
 end
end
