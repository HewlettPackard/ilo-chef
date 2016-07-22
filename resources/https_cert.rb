# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

actions :import, :generate_csr

property :ilo, Hash
property :certificate, String
property :file, String
property :country, String
property :state, String
property :city, String
property :orgName, String
property :orgUnit, String
property :commonName, String

action_class do
  include IloHelper
end

action :import do
  load_sdk
  raise "Please provide Certificate String or File!" unless certificate || file
  raise "Please ONLY provide either Certificate String or File!" if certificate && file
  client = build_client(ilo)
  cur_certificate = ilo.get_certificate.to_s
  if certificate
    next if cur_certificate.gsub(/\s+/, '') == certificate.gsub(/\s+/, '')
    converge_by "Importing new certificate" do
      client.import_certificate(certificate)
    end
  elsif file
    cert = File.open(file).read
    #clean_cert = cert.gsub!(/.*?(?=-----BEGIN CERTIFICATE-----)/im, "")
    #clean_cert = cert.gsub!(/(?=-----END CERTIFICATE-----).*?/im, "")
    next if cur_certificate.gsub(/\s+/, '') == cert.gsub(/\s+/, '')
    converge_by "Importing new certificate" do
      client.import_certificate(cert)
    end
  end
end

action :generate_csr do
  load_sdk
  client = build_client(ilo)
  converge_by "Generating CSR and placing it in '#{file}'" do
    csr = client.generate_csr(country, state, city, orgName, orgUnit, commonName)
    csr_file = File.open(file, 'w')
    csr_file.syswrite(csr)
  end
end
