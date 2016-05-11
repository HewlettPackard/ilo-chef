ilo =
{
    host: '16.85.179.65',
    user: 'Admin',
    password: 'admin123',
    ssl_enabled: false
}

iLO_power "power off" do
  ilos [ilo]
  action :poweroff
end

iLO_power "power on" do
  ilos [ilo]
  action :poweron
end

iLO_power "reset sys" do
  ilos [ilo]
  action :resetsys
end

iLO_power "reset ilo" do
  ilos [ilo]
  action :resetilo
end
