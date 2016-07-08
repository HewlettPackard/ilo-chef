ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_snmp_service 'configure SNMP service' do
  ilos [ilo]
  snmp_mode 'Passthru'
  snmp_alerts true
  action :configure
end
