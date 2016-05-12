ilo =
{
    host: '16.85.179.65',
    user: 'Admin',
    password: 'admin123',
    ssl_enabled: false
}

iLO_snmp_service '' do
  ilos [ilo]
  snmp_mode 'Passthru'
  snmp_alerts true
  action :configure
end

iLO_snmp_service '' do
  ilos [ilo]
  snmp_mode 'Agentless'
  snmp_alerts false
  action :configure
end
