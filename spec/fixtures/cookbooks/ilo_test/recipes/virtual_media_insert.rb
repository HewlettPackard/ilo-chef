# Cookbook Name:: ilo_test
# Recipe:: virtual_media_insert
#
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
#

ilo_virtual_media 'insert virtual media' do
  ilos node['ilo_test']['ilos']
  iso_uri 'http://1.1.1.1:5000/ubuntu-15.04-desktop-amd64.iso'
  action :insert
end
