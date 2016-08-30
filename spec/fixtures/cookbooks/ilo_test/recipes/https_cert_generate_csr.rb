# Cookbook Name:: ilo_test
# Recipe:: https_cert_generate_csr
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

ilo_https_cert 'generate csr' do
  ilo node['ilo_test']['ilo1']
  country 'US'
  state 'Texas'
  city 'Houston'
  orgName 'Example Company'
  orgUnit 'Example'
  commonName 'ILO.americas.example.net'
  action :generate_csr
end
