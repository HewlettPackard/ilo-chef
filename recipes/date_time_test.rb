ilo =
{
    host: '16.85.179.65',
    user: 'Admin',
    password: 'admin123',
    ssl_enabled: false
}

iLO_date_time 'set time zone' do
  ilos [ilo]
  time_zone 'Africa/Abidjan'
  action :set
end

iLO_date_time 'set time zone' do
  ilos [ilo]
  time_zone 'Asia/Macau'
  action :set
end

iLO_date_time 'use ntp' do
  ilos [ilo]
  value true
  action :set_ntp
end

iLO_date_time 'use ntp' do
  ilos [ilo]
  value false
  action :set_ntp
end

iLO_date_time 'set ntp servers' do
  ilos [ilo]
  ntp_servers [
    "111.111.111.1",
    "11.111.111.1"
  ]
  action :set_ntp_servers
end

iLO_date_time 'set ntp servers' do
  ilos [ilo]
  ntp_servers [
    "192.168.0.3",
    "192.168.0.2"
  ]
  action :set_ntp_servers
end
