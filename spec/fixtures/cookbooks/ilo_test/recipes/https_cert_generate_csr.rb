ilo1 =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_https_cert 'generate csr' do
  ilo ilo1
  country 'US'
  state 'Texas'
  city 'Houston'
  orgName 'Example Company'
  orgUnit 'Example'
  commonName 'ILO.americas.example.net'
  action :generate_csr
end
