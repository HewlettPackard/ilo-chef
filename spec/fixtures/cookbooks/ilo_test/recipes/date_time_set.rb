ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_date_time 'set time zone, NTP, and NTP servers' do
  ilos [ilo]
  time_zone 'Africa/Abidjan'
  use_ntp true
  ntp_servers [
    '1.1.1.1',
    '2.2.2.2'
  ]
  action :set
end
