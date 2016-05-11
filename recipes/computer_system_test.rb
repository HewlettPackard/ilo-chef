ilo =
{
    host: '16.85.179.65',
    user: 'Admin',
    password: 'admin123',
    ssl_enabled: false
}

iLO_computer_system "set asset tag" do
  ilos [ilo]
  asset_tag "HP002"
  action :set
end

iLO_computer_system "set indicator led" do
  ilos [ilo]
  led_state "Lit"
  action :set
end

iLO_computer_system "set asset tag and indicator led" do
  ilos [ilo]
  asset_tag "HP001"
  led_state "Off"
  action :set
end
